export function positiveId(value) {
  const n = Number(value);
  if (!Number.isSafeInteger(n) || n <= 0) throw new Error('Choose a valid customer or product.');
  return n;
}
export function validateItems(items) {
  if (!Array.isArray(items) || !items.length || items.length > 50) throw new Error('Your cart must contain 1–50 products.');
  const seen = new Set();
  return items.map(item => {
    const productId = positiveId(item.productId);
    if (seen.has(productId)) throw new Error('Duplicate product in cart.');
    seen.add(productId);
    const quantity = Number(item.quantity);
    if (!Number.isSafeInteger(quantity) || quantity < 1 || quantity > 99) throw new Error('Quantity must be between 1 and 99.');
    return {productId, quantity};
  }).sort((a,b) => a.productId-b.productId);
}
export function validateReview(body) {
  const userId=positiveId(body.userId), productId=positiveId(body.productId), rating=Number(body.rating);
  if (!Number.isInteger(rating) || rating < 1 || rating > 5) throw new Error('Rating must be between 1 and 5.');
  const comment=String(body.comment ?? '').trim();
  if (comment.length > 500) throw new Error('Review must be 500 characters or fewer.');
  return {userId,productId,rating,comment};
}
