// Business logic kept separate from the HTTP layer so it can be unit tested.

function applyDiscount(price, percent) {
  if (typeof price !== 'number' || price < 0) throw new Error('price must be a non-negative number');
  if (percent < 0 || percent > 100) throw new Error('percent must be between 0 and 100');
  return Math.round(price * (100 - percent)) / 100;
}

function totalWithTax(items, taxRate = 0.1) {
  const subtotal = items.reduce((sum, i) => sum + i.price * i.qty, 0);
  return Math.round(subtotal * (1 + taxRate) * 100) / 100;
}

module.exports = { applyDiscount, totalWithTax };
