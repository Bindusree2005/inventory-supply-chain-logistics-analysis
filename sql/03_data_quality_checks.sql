-- Validate data quality

-- A) Validate your data quality

SELECT
    p.product_name,
    w.warehouse_name,
    i.stock_quantity,
    p.reorder_level
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
WHERE i.stock_quantity < p.reorder_level
ORDER BY i.stock_quantity;

-- B) Check for invalid delivered shipments

SELECT *
FROM shipments
WHERE shipment_status = 'Delivered'
  AND actual_delivery_date IS NULL;
  
-- C) Check for invalid inventory quantities

SELECT *
FROM inventory
WHERE stock_quantity < 0;
