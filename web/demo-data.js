// Clearly labelled, read-only preview based on the supplied sample-data SQL.
const specs=[
 [201,'Smartphone X1',10,'Electronics','NovaTech',24999,25,'5G smartphone with 128 GB storage',5,1],
 [202,'Wireless Headphones',10,'Electronics','SoundMax',2999,40,'Bluetooth headphones with noise cancellation',4,1],
 [203,'Laptop Pro 14',10,'Electronics','TechBook',64999,15,'14-inch laptop with 16 GB RAM',0,0],
 [204,'Mens Casual Shirt',20,'Fashion','UrbanStyle',1299,50,'Cotton casual shirt for men',3,1],
 [205,'Womens Running Shoes',20,'Fashion','ActiveWear',2499,35,'Lightweight running shoes for women',4,1],
 [206,'Mixer Grinder',30,'Home and Kitchen','HomePro',3499,20,'Three-jar kitchen mixer grinder',0,0],
 [207,'LED Study Lamp',30,'Home and Kitchen','BrightHome',899,45,'Rechargeable LED desk lamp',0,0],
 [208,'Database Management Systems',40,'Books','TechPress',799,60,'Introductory textbook on database systems',5,1],
 [209,'Yoga Mat',50,'Sports','FitLife',699,55,'Non-slip exercise and yoga mat',5,1],
 [210,'Cricket Bat',50,'Sports','SportStar',1999,30,'English-willow practice cricket bat',4,1]
];
const keys=['PRODUCT_ID','PRODUCT_NAME','CATEGORY_ID','CATEGORY_NAME','BRAND','PRICE','STOCK_QUANTITY','DESCRIPTION','AVERAGE_RATING','REVIEW_COUNT'];
const products=specs.map(p=>Object.fromEntries(keys.map((k,i)=>[k,p[i]])));
const customers=['Aarav Sharma','Diya Reddy','Arjun Kumar','Meera Patel','Rohan Singh','Ananya Rao','Vikram Das'].map((Name,i)=>({USER_ID:101+i,NAME:Name}));
export function demoData(route,url){
 if(route==='/api/products')return products;
 if(route==='/api/customers')return customers;
 if(route==='/api/recommendations')return [209,208,201,202,205].map(id=>({PRODUCT_ID:id,HYBRID_SCORE:products.find(p=>p.PRODUCT_ID===id).AVERAGE_RATING*2,REASON:'Sample highly rated product — preview'}));
 if(route==='/api/orders')return []; // Do not present invented order history as live data.
 if(route==='/api/reviews')return [];
 throw Object.assign(new Error('Not found.'),{status:404});
}
