-- step1--> Classify inventory stock status
SELECT
    p.product_name,
    w.warehouse_name,
    i.stock_quantity,
    p.reorder_level,
    CASE
        WHEN i.stock_quantity < p.reorder_level
            THEN 'Low Stock'
        WHEN i.stock_quantity = p.reorder_level
            THEN 'At Reorder Level'
        ELSE 'Sufficient Stock'
    END AS stock_status
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
ORDER BY stock_status, i.stock_quantity;

-- Step 2: Calculate inventory value
SELECT
    p.product_name,
    w.warehouse_name,
    i.stock_quantity,
    p.unit_cost,
    i.stock_quantity * p.unit_cost AS inventory_value
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
ORDER BY inventory_value DESC;

-- Step 3: Calculate total inventory value
SELECT
    SUM(i.stock_quantity * p.unit_cost) AS total_inventory_value
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id;
    
-- Step 4: Calculate inventory value by warehouse
SELECT
    w.warehouse_name,
    SUM(i.stock_quantity * p.unit_cost) AS total_inventory_value
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
GROUP BY
    w.warehouse_id,
    w.warehouse_name
ORDER BY total_inventory_value DESC;

-- Step 5: Identify products that need replenishment
SELECT
    p.product_name,
    w.warehouse_name,
    i.stock_quantity,
    p.reorder_level,
    p.reorder_level - i.stock_quantity AS units_to_reorder
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
WHERE i.stock_quantity < p.reorder_level
ORDER BY units_to_reorder DESC;

-- Step 6: Which warehouse has the most low-stock products?
SELECT
    w.warehouse_name,
    COUNT(*) AS low_stock_products,
    SUM(p.reorder_level - i.stock_quantity) AS total_units_to_reorder
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
WHERE i.stock_quantity < p.reorder_level
GROUP BY
    w.warehouse_id,
    w.warehouse_name
ORDER BY total_units_to_reorder DESC;

-- Step 7: Calculate total purchase order value
SELECT
    po.po_id,
    s.supplier_name,
    po.order_date,
    po.po_status,
    SUM(poi.quantity_ordered * poi.unit_cost) AS purchase_order_value
FROM purchase_orders po
JOIN suppliers s
    ON po.supplier_id = s.supplier_id
JOIN purchase_order_items poi
    ON po.po_id = poi.po_id
GROUP BY
    po.po_id,
    s.supplier_name,
    po.order_date,
    po.po_status
ORDER BY purchase_order_value DESC;

-- Step 8: Compare total purchasing value by supplier
SELECT
    s.supplier_name,
    COUNT(DISTINCT po.po_id) AS total_purchase_orders,
    SUM(poi.quantity_ordered * poi.unit_cost) AS total_purchase_value
FROM suppliers s
JOIN purchase_orders po
    ON s.supplier_id = po.supplier_id
JOIN purchase_order_items poi
    ON po.po_id = poi.po_id
GROUP BY
    s.supplier_id,
    s.supplier_name
ORDER BY total_purchase_value DESC;

-- Step 9: Analyze shipment delivery performance
SELECT
    shipment_status,
    COUNT(*) AS total_shipments,
    SUM(
        CASE
            WHEN actual_delivery_date IS NOT NULL
             AND actual_delivery_date <= expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS on_time_shipments,
    SUM(
        CASE
            WHEN actual_delivery_date > expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delayed_shipments
FROM shipments
GROUP BY shipment_status
ORDER BY shipment_status;

-- Step 9: Calculate on-time delivery rate by carrier
SELECT
    carrier_name,
    COUNT(*) AS total_shipments,
    SUM(
        CASE
            WHEN actual_delivery_date IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS delivered_shipments,
    SUM(
        CASE
            WHEN actual_delivery_date IS NOT NULL
             AND actual_delivery_date <= expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS on_time_shipments,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN actual_delivery_date IS NOT NULL
                 AND actual_delivery_date <= expected_delivery_date
                THEN 1
                ELSE 0
            END
        ) / NULLIF(
            SUM(
                CASE
                    WHEN actual_delivery_date IS NOT NULL
                    THEN 1
                    ELSE 0
                END
            ), 0
        ),
        2
    ) AS on_time_delivery_rate
FROM shipments
GROUP BY carrier_name
ORDER BY on_time_delivery_rate DESC;

-- Step 10: Analyze monthly sales revenue
SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS sales_month,
    SUM(quantity_sold) AS total_units_sold,
    SUM(quantity_sold * unit_price) AS total_sales_revenue
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY sales_month;

-- Step 11: Find the top-selling products by revenue
SELECT
    p.product_name,
    SUM(s.quantity_sold) AS total_units_sold,
    SUM(s.quantity_sold * s.unit_price) AS total_revenue
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC;

-- Step 12: Calculate revenue by warehouse
SELECT
    w.warehouse_name,
    SUM(s.quantity_sold) AS total_units_sold,
    SUM(s.quantity_sold * s.unit_price) AS total_revenue
FROM sales s
JOIN warehouses w
    ON s.warehouse_id = w.warehouse_id
GROUP BY
    w.warehouse_id,
    w.warehouse_name
ORDER BY total_revenue DESC;

-- Step 13: Compare inventory with sales
SELECT
    p.product_name,
    w.warehouse_name,
    i.stock_quantity,
    p.reorder_level,
    COALESCE(SUM(s.quantity_sold), 0) AS total_units_sold
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
LEFT JOIN sales s
    ON i.product_id = s.product_id
   AND i.warehouse_id = s.warehouse_id
WHERE i.stock_quantity < p.reorder_level
GROUP BY
    p.product_id,
    p.product_name,
    w.warehouse_id,
    w.warehouse_name,
    i.stock_quantity,
    p.reorder_level
ORDER BY total_units_sold DESC;

-- Step 14: One data check before moving to Power BI
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
LEFT JOIN sales s
    ON i.product_id = s.product_id
   AND i.warehouse_id = s.warehouse_id
WHERE i.stock_quantity < p.reorder_level
  AND s.sale_id IS NULL;
  
  select * from shipments;
  use inventory_supply_chain;
