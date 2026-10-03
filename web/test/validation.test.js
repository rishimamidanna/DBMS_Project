import test from 'node:test';
import assert from 'node:assert/strict';
import {positiveId,validateItems,validateReview} from '../validation.js';
test('IDs accept integer strings and reject invalid values',()=>{assert.equal(positiveId('101'),101);for(const v of [0,-1,null,'x',1.5,Infinity])assert.throws(()=>positiveId(v));});
test('cart validates, sorts and ignores client prices',()=>{assert.deepEqual(validateItems([{productId:202,quantity:2,price:1},{productId:201,quantity:1}]),[{productId:201,quantity:1},{productId:202,quantity:2}]);});
test('cart rejects missing, duplicate and invalid quantities',()=>{for(const items of [[],null,[{productId:201,quantity:0}],[{productId:201,quantity:100}],[{productId:201,quantity:1.5}],[{productId:201,quantity:1},{productId:201,quantity:2}]])assert.throws(()=>validateItems(items));});
test('reviews validate ratings and character limit',()=>{assert.equal(validateReview({userId:101,productId:201,rating:5,comment:' Great '}).comment,'Great');for(const rating of [0,6,1.5,'bad'])assert.throws(()=>validateReview({userId:101,productId:201,rating}));assert.throws(()=>validateReview({userId:101,productId:201,rating:5,comment:'a'.repeat(501)}));});
