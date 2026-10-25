const { applyDiscount, totalWithTax } = require('../src/pricing');

describe('applyDiscount', () => {
  test('applies a percentage discount', () => {
    expect(applyDiscount(200, 25)).toBe(150);
  });

  test('rejects a negative price', () => {
    expect(() => applyDiscount(-1, 10)).toThrow('non-negative');
  });

  test('rejects a discount above 100', () => {
    expect(() => applyDiscount(100, 120)).toThrow('between 0 and 100');
  });
});

describe('totalWithTax', () => {
  test('adds 10% tax by default', () => {
    expect(totalWithTax([{ price: 10, qty: 2 }, { price: 5, qty: 1 }])).toBe(27.5);
  });
});
