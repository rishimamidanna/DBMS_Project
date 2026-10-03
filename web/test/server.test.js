import test from 'node:test';
import assert from 'node:assert/strict';
import {spawn} from 'node:child_process';
import {fileURLToPath} from 'node:url';
const cwd=fileURLToPath(new URL('..',import.meta.url));
test('preview serves catalogue, protects writes and blocks cross-origin requests',async()=>{
 const server=spawn(process.execPath,['server.js','--demo'],{cwd,env:{...process.env,PORT:'3099',DB_PASSWORD:''},stdio:['ignore','pipe','pipe']});
 try{
  await new Promise((resolve,reject)=>{const timer=setTimeout(()=>reject(new Error('Server did not start')),10000);server.once('error',reject);server.once('exit',code=>reject(new Error('Server exited: '+code)));server.stdout.on('data',data=>{if(String(data).includes('http://localhost:3099')){clearTimeout(timer);resolve();}});});
  const status=await (await fetch('http://localhost:3099/api/status')).json();assert.equal(status.mode,'demo');assert.equal(status.connected,false);
  const products=await (await fetch('http://localhost:3099/api/products')).json();assert.equal(products.length,10);assert.equal(products[0].PRICE,24999);
  assert.ok(!JSON.stringify(products).includes('PASSWORD'));
  const page=await fetch('http://localhost:3099/');assert.equal(page.status,200);assert.match(page.headers.get('content-security-policy'),/frame-ancestors 'none'/);
  const write=await fetch('http://localhost:3099/api/checkout',{method:'POST',headers:{Origin:'http://localhost:3099','Content-Type':'application/json'},body:JSON.stringify({userId:101,items:[{productId:201,quantity:1}]})});assert.equal(write.status,403);assert.match((await write.json()).error,/read-only/);
  const crossOrigin=await fetch('http://localhost:3099/api/connect',{method:'POST',headers:{Origin:'https://example.com','Content-Type':'application/json'},body:'{}'});assert.equal(crossOrigin.status,403);
  const missing=await fetch('http://localhost:3099/.env');assert.equal(missing.status,404);
 }finally{server.kill('SIGTERM');}
});
