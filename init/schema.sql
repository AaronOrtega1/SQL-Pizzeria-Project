-- ===================================
-- Orders Area
-- ===================================

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

CREATE TABLE address (
    address_id SERIAL PRIMARY KEY,
    delivery_address1 VARCHAR(200) NOT NULL,
    delivery_address2 VARCHAR(200),
    delivery_city VARCHAR(50) NOT NULL,
    delivery_zipcode VARCHAR(20) NOT NULL
);

CREATE TABLE products (
    item_id VARCHAR(10) PRIMARY KEY,
    sku VARCHAR(20) UNIQUE NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    item_cat VARCHAR(100),
    item_size VARCHAR(10),
    item_price DECIMAL(10, 2) NOT NULL CHECK (item_price >= 0)
);

CREATE TABLE ingredient (
    ing_id VARCHAR(10) PRIMARY KEY,
    ing_name VARCHAR(200) NOT NULL,
    ing_weight INTEGER NOT NULL CHECK (ing_weight > 0),
    ing_meas VARCHAR(20) NOT NULL,
    ing_price DECIMAL(5, 2) NOT NULL CHECK (ing_price >= 0)
);

CREATE TABLE orders (
    row_id SERIAL PRIMARY KEY,
    order_id VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    delivery BOOLEAN DEFAULT FALSE,
    customer_id INTEGER NOT NULL REFERENCES customers (customer_id),
    address_id INTEGER NOT NULL REFERENCES address (address_id),
    item_id VARCHAR(10) NOT NULL REFERENCES products (item_id)
);

CREATE TABLE recipe (
    row_id SERIAL PRIMARY KEY,
    recipe_id VARCHAR(20) NOT NULL REFERENCES products (sku),
    ing_id VARCHAR(10) NOT NULL REFERENCES ingredient (ing_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0)
);

CREATE TABLE inventory (
    inv_id SERIAL PRIMARY KEY,
    item_id VARCHAR(10) NOT NULL REFERENCES products (item_id),
    quantity INTEGER NOT NULL CHECK (quantity >= 0)
);

-- ===================================
-- Staff Area
-- ===================================

CREATE TABLE staff (
    staff_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(100),
    hourly_rate BIGINT NOT NULL CHECK (hourly_rate >= 0)
);

CREATE TABLE shift (
    shift_id VARCHAR(20) PRIMARY KEY,
    day_of_week VARCHAR(10) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

CREATE TABLE rota (
    row_id SERIAL PRIMARY KEY,
    rota_id VARCHAR(30) NOT NULL,
    date DATE NOT NULL,
    shift_id VARCHAR(20) NOT NULL REFERENCES shift (shift_id),
    staff_id VARCHAR(20) NOT NULL REFERENCES staff (staff_id)
);

-- ===================================
-- Indexes for Analytical Joins
-- ===================================

CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_orders_item_id ON orders (item_id);
CREATE INDEX idx_orders_address_id ON orders (address_id);

CREATE INDEX idx_recipe_item_id ON recipe (recipe_id);
CREATE INDEX idx_recipe_ing_id ON recipe (ing_id);

CREATE INDEX idx_inventory_item_id ON inventory (item_id);

CREATE INDEX idx_rota_staff_id ON rota (staff_id);
CREATE INDEX idx_rota_shift_id ON rota (shift_id);

