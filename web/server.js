import http from 'node:http';
import {readFile} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import oracledb from 'oracledb';
import {positiveId,validateItems,validateReview} from './validation.js';
import {demoData} from './demo-data.js';

const root=path.dirname(fileURLToPath(import.meta.url));
const port=Number(process.env.PORT || 3000);
const demo=process.argv.includes('--demo');
let pool=null;
oracledb.outFormat=oracledb.OUT_FORMAT_OBJECT;
const config={user:process.env.DB_USER || 'smart_ecommerce',password:process.env.DB_PASSWORD,connectString:process.env.DB_CONNECT_STRING || 'localhost:1521/FREEPDB1'};
const json=(res,status,data)=>{res.writeHead(status,{'Content-Type':'application/json','Cache-Control':'no-store'});res.end(JSON.stringify(data));};
const rows=async(c,sql,binds={})=>(await c.execute(sql,binds)).rows;
async function connection(fn){if(!pool)throw Object.assign(new Error('Oracle is not connected. Use Connect Oracle or configure your .env file.'),{status:503});const c=await pool.getConnection();c.callTimeout=15000;try{return await fn(c);}finally{await c.close();}}
async function connect(password){
  if(pool)return;
  const candidate=await oracledb.createPool({...config,password,poolMin:0,poolMax:4,poolIncrement:1,queueTimeout:10000});
  try{const c=await candidate.getConnection();try{await c.execute('SELECT Product_ID FROM Product WHERE 1=0');await c.execute('SELECT User_ID FROM App_User WHERE 1=0');}finally{await c.close();}pool=candidate;}catch(e){await candidate.close(0);throw e;}
}
async function body(req){let raw='';for await(const chunk of req){raw+=chunk;if(raw.length>20000)throw Object.assign(new Error('Request too large.'),{status:413});}try{return JSON.parse(raw || '{}');}catch{throw Object.assign(new Error('Invalid request.'),{status:400});}}
async function customer(c,userId){const found=await rows(c,"SELECT User_ID FROM App_User WHERE User_ID=:id AND Role='CUSTOMER'",{id:userId});if(!found.length)throw new Error('Select an existing customer.');}
// Existing schema has manual primary keys. A short exclusive lock serializes ID allocation
// across this demo and other database sessions; no sequences or new tables are created.
async function nextId(c,table,column){await c.execute(`LOCK TABLE ${table} IN EXCLUSIVE MODE WAIT 5`);return (await rows(c,`SELECT NVL(MAX(${column}),0)+1 AS ID FROM ${table}`))[0].ID;}
async function interaction(c,userId,productId,type){const id=await nextId(c,'Product_Interaction','Interaction_ID');await c.execute('INSERT INTO Product_Interaction (Interaction_ID,User_ID,Product_ID,Interaction_Type) VALUES (:id,:userId,:productId,:type)',{id,userId,productId,type});}
const productSQL=`SELECT P.Product_ID, P.Product_Name, P.Brand, P.Price, P.Stock_Quantity, P.Description, C.Category_ID, C.Category_Name, NVL(R.Average_Rating,0) Average_Rating, NVL(R.Review_Count,0) Review_Count
 FROM Product P JOIN Category C ON C.Category_ID=P.Category_ID
 LEFT JOIN (SELECT Product_ID,ROUND(AVG(Rating),2) Average_Rating,COUNT(*) Review_Count FROM Review GROUP BY Product_ID) R ON R.Product_ID=P.Product_ID ORDER BY P.Product_ID`;
async function api(req,res,url){
  const route=url.pathname;
  if(route==='/api/status' && req.method==='GET')return json(res,200,{connected:!!pool,mode:demo?'demo':'oracle',user:config.user,connectString:config.connectString});
  if(route==='/api/connect' && req.method==='POST'){
    if(demo)return json(res,409,{error:'Restart with npm start to connect to Oracle.'});
    const input=await body(req);if(typeof input.password!=='string'||!input.password)throw new Error('Enter your Oracle schema password.');
    await connect(input.password);return json(res,200,{connected:true});
  }
  if(req.method==='GET'){
    if(demo)return json(res,200,demoData(route,url));
    const result=await connection(async c=>{
      if(route==='/api/products')return rows(c,productSQL);
      if(route==='/api/customers')return rows(c,"SELECT User_ID,Name FROM App_User WHERE Role='CUSTOMER' ORDER BY User_ID");
      if(route==='/api/orders'){
        const id=positiveId(url.searchParams.get('userId'));await customer(c,id);
        const orders=await rows(c,'SELECT Order_ID,Order_Date,Total_Amount,Order_Status FROM Orders WHERE User_ID=:id ORDER BY Order_Date DESC,Order_ID DESC',{id});
        const items=await rows(c,'SELECT OI.Order_ID, P.Product_Name, OI.Quantity, OI.Unit_Price FROM Order_Item OI JOIN Product P ON P.Product_ID=OI.Product_ID JOIN Orders O ON O.Order_ID=OI.Order_ID WHERE O.User_ID=:id ORDER BY OI.Order_Item_ID',{id});
        return orders.map(o=>({...o,ITEMS:items.filter(i=>i.ORDER_ID===o.ORDER_ID)}));
      }
      if(route==='/api/reviews')return rows(c,'SELECT R.Rating,R.Review_Comment,R.Review_Date,U.Name FROM Review R JOIN App_User U ON U.User_ID=R.User_ID WHERE R.Product_ID=:id ORDER BY R.Review_Date DESC',{id:positiveId(url.searchParams.get('productId'))});
      if(route==='/api/recommendations'){
        const id=positiveId(url.searchParams.get('userId'));await customer(c,id);
        // Aggregate ratings and interactions separately to avoid multiplying counts in a join.
        return rows(c,`SELECT P.Product_ID, NVL(R.Avg_Rating,0)*2+NVL(I.Interaction_Count,0) AS Hybrid_Score,
          CASE WHEN EXISTS (SELECT 1 FROM Product_Interaction PI JOIN Product P2 ON P2.Product_ID=PI.Product_ID WHERE PI.User_ID=:id AND P2.Category_ID=P.Category_ID AND PI.Interaction_Type='VIEW') THEN 'From a category you viewed' WHEN NVL(R.Avg_Rating,0)>=4 THEN 'Highly rated by customers' ELSE 'Discover something new' END AS Reason
          FROM Product P LEFT JOIN (SELECT Product_ID,AVG(Rating) Avg_Rating FROM Review GROUP BY Product_ID) R ON R.Product_ID=P.Product_ID
          LEFT JOIN (SELECT Product_ID,COUNT(*) Interaction_Count FROM Product_Interaction GROUP BY Product_ID) I ON I.Product_ID=P.Product_ID
          WHERE P.Stock_Quantity>0 AND NOT EXISTS (SELECT 1 FROM Product_Interaction PI WHERE PI.User_ID=:id AND PI.Product_ID=P.Product_ID)
          ORDER BY Hybrid_Score DESC,P.Product_ID FETCH FIRST 5 ROWS ONLY`,{id});
      }
      throw Object.assign(new Error('Not found.'),{status:404});
    });return json(res,200,result);
  }
  if(demo)return json(res,403,{error:'Preview mode is read-only. Connect Oracle to save changes.'});
  if(req.method!=='POST')return json(res,405,{error:'Method not allowed.'});
  const input=await body(req);
  const result=await connection(async c=>{
    try{
      if(route==='/api/interactions'){
        const userId=positiveId(input.userId), productId=positiveId(input.productId);await customer(c,userId);
        if(!['VIEW','CART','WISHLIST'].includes(input.type))throw new Error('Invalid interaction.');
        await interaction(c,userId,productId,input.type);await c.commit();return {saved:true};
      }
      if(route==='/api/reviews'){
        const review=validateReview(input);await customer(c,review.userId);const id=await nextId(c,'Review','Review_ID');
        await c.execute(`MERGE INTO Review R USING (SELECT :userId U,:productId P FROM DUAL) S ON (R.User_ID=S.U AND R.Product_ID=S.P)
          WHEN MATCHED THEN UPDATE SET R.Rating=:rating,R.Review_Comment=:comment,R.Review_Date=SYSDATE
          WHEN NOT MATCHED THEN INSERT (Review_ID,User_ID,Product_ID,Rating,Review_Comment) VALUES (:id,:userId,:productId,:rating,:comment)`,{...review,id});
        await c.commit();return {saved:true};
      }
      if(route==='/api/checkout'){
        const userId=positiveId(input.userId), items=validateItems(input.items);await customer(c,userId);
        // Consistent lock order and transaction: header, lines, inventory and interactions succeed together.
        const orderId=await nextId(c,'Orders','Order_ID');let itemId=await nextId(c,'Order_Item','Order_Item_ID');
        const priced=[];let totalCents=0;
        for(const item of items){const [p]=await rows(c,'SELECT Product_ID,Product_Name,Price,Stock_Quantity FROM Product WHERE Product_ID=:id FOR UPDATE WAIT 5',{id:item.productId});if(!p||p.STOCK_QUANTITY<item.quantity)throw new Error(`Insufficient stock for ${p?.PRODUCT_NAME || 'this product'}.`);priced.push({...item,price:p.PRICE});totalCents+=Math.round(p.PRICE*100)*item.quantity;}
        await c.execute("INSERT INTO Orders (Order_ID,User_ID,Total_Amount,Order_Status) VALUES (:orderId,:userId,:total,'CONFIRMED')",{orderId,userId,total:totalCents/100});
        for(const item of priced){await c.execute('INSERT INTO Order_Item (Order_Item_ID,Order_ID,Product_ID,Quantity,Unit_Price) VALUES (:id,:orderId,:productId,:quantity,:price)',{id:itemId++,orderId,...item});await c.execute('UPDATE Product SET Stock_Quantity=Stock_Quantity-:quantity WHERE Product_ID=:id',{quantity:item.quantity,id:item.productId});await interaction(c,userId,item.productId,'PURCHASE');}
        await c.execute('UPDATE Cart SET Updated_At=SYSDATE WHERE User_ID=:userId',{userId});
        await c.commit();return {orderId,total:totalCents/100};
      }
      throw Object.assign(new Error('Not found.'),{status:404});
    }catch(e){await c.rollback();throw e;}
  });json(res,200,result);
}
const server=http.createServer(async(req,res)=>{
  res.setHeader('X-Content-Type-Options','nosniff');res.setHeader('Referrer-Policy','no-referrer');res.setHeader('X-Frame-Options','DENY');
  res.setHeader('Content-Security-Policy',"default-src 'self'; img-src 'self' data:; style-src 'self'; script-src 'self'; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'");
  try{
    // Local-only demo by default; allows cloud hosts (like Vercel) if ALLOW_REMOTE is set or running in production/cloud environments
    const isLocal=['localhost:'+port,'127.0.0.1:'+port].includes(req.headers.host);
    const allowRemote=process.env.ALLOW_REMOTE==='true'||process.env.VERCEL==='1'||Boolean(process.env.VERCEL_URL);
    if(!isLocal && !allowRemote)return json(res,403,{error:'Local access only.'});
    if(req.method==='POST' && !allowRemote && (!['http://localhost:'+port,'http://127.0.0.1:'+port].includes(req.headers.origin)||!req.headers['content-type']?.startsWith('application/json')))return json(res,403,{error:'Invalid request origin.'});
    const url=new URL(req.url,`http://${req.headers.host || 'localhost'}`);if(url.pathname.startsWith('/api/'))return await api(req,res,url);
    if(req.method!=='GET')return json(res,405,{error:'Method not allowed.'});
    const files={'/':'index.html','/app.js':'app.js','/styles.css':'styles.css','/art.svg':'art.svg'};
    const file=files[url.pathname];if(!file)return json(res,404,{error:'Not found.'});
    const types={'.html':'text/html','.js':'text/javascript','.css':'text/css','.svg':'image/svg+xml'};
    res.writeHead(200,{'Content-Type':types[path.extname(file)]});res.end(await readFile(path.join(root,'public',file)));
  }catch(e){
    let message=e.message;
    if(/ORA-00001/.test(message))message='This record already exists.';
    else if(/ORA-02291/.test(message))message='Customer or product no longer exists. Refresh and try again.';
    else if(/ORA-|NJS-/.test(message))message='Oracle request failed. Check the schema credentials, database readiness and required tables.';
    json(res,e.status || 400,{error:message});
  }
});
if(config.password&&!demo){try{await connect(config.password);}catch{console.warn('Oracle connection unavailable. Open the website to connect.');}}
server.listen(port,'127.0.0.1',()=>console.log(`Smart E-Commerce: http://localhost:${port} (${demo?'read-only preview':pool?'Oracle connected':'awaiting Oracle password'})`));
let stopping=false;
for(const signal of ['SIGINT','SIGTERM'])process.on(signal,()=>{
  if(stopping)return;
  stopping=true;
  server.close(async()=>{try{if(pool)await pool.close(3);}finally{process.exit(0);}});
});
