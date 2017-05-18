-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Thu May 18 20:06:52 2017
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS addons;

--
-- Table: addons
--
CREATE TABLE addons (
  id integer NOT NULL,
  name VARCHAR(50) NOT NULL,
  is_enabled TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE addons_name (name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS addresses;

--
-- Table: addresses
--
CREATE TABLE addresses (
  id integer NOT NULL auto_increment,
  line1 VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS carts;

--
-- Table: carts
--
CREATE TABLE carts (
  cart_id VARCHAR(50) NOT NULL,
  data MEDIUMTEXT NOT NULL,
  created_at datetime NOT NULL,
  updated_at datetime NOT NULL,
  PRIMARY KEY (cart_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS customers;

--
-- Table: customers
--
CREATE TABLE customers (
  id integer NOT NULL auto_increment,
  created_at datetime NOT NULL,
  updated_at datetime NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS emails;

--
-- Table: emails
--
CREATE TABLE emails (
  id integer NOT NULL auto_increment,
  address VARCHAR(255) NOT NULL,
  is_verified enum('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS my_addon_tests;

--
-- Table: my_addon_tests
--
CREATE TABLE my_addon_tests (
  id VARCHAR(50) NOT NULL,
  data MEDIUMTEXT NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS order_sequences;

--
-- Table: order_sequences
--
CREATE TABLE order_sequences (
  id integer NOT NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS preferences;

--
-- Table: preferences
--
CREATE TABLE preferences (
  key_name VARCHAR(50) NOT NULL,
  value text NULL,
  default_value text NOT NULL,
  summary text NULL,
  position integer NULL DEFAULT 0,
  group_id integer NULL DEFAULT 0,
  PRIMARY KEY (key_name)
);

DROP TABLE IF EXISTS reference_address_types;

--
-- Table: reference_address_types
--
CREATE TABLE reference_address_types (
  type CHAR(4) NOT NULL,
  PRIMARY KEY (type)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS addon_hooks;

--
-- Table: addon_hooks
--
CREATE TABLE addon_hooks (
  id integer NOT NULL,
  addon_id integer NULL,
  hook_name VARCHAR(50) NULL,
  priority integer NULL DEFAULT 100,
  INDEX addon_hooks_idx_addon_id (addon_id),
  PRIMARY KEY (id),
  CONSTRAINT addon_hooks_fk_addon_id FOREIGN KEY (addon_id) REFERENCES addons (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS sessions;

--
-- Table: sessions
--
CREATE TABLE sessions (
  sid VARCHAR(50) NOT NULL,
  data MEDIUMTEXT NULL,
  cart_id VARCHAR(50) NOT NULL,
  expires BIGINT NOT NULL,
  INDEX sessions_idx_cart_id (cart_id),
  PRIMARY KEY (sid),
  CONSTRAINT sessions_fk_cart_id FOREIGN KEY (cart_id) REFERENCES carts (cart_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS customer_emails;

--
-- Table: customer_emails
--
CREATE TABLE customer_emails (
  id integer NOT NULL auto_increment,
  customer_id integer NOT NULL,
  email_id integer NOT NULL,
  is_primary enum('0','1') NOT NULL DEFAULT '0',
  INDEX customer_emails_idx_email_id (email_id),
  INDEX customer_emails_idx_customer_id (customer_id),
  PRIMARY KEY (id),
  UNIQUE ui_customer_id_email_id (customer_id, email_id),
  CONSTRAINT customer_emails_fk_email_id FOREIGN KEY (email_id) REFERENCES emails (id) ON DELETE CASCADE,
  CONSTRAINT customer_emails_fk_customer_id FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS sales_order_headers;

--
-- Table: sales_order_headers
--
CREATE TABLE sales_order_headers (
  id integer NOT NULL auto_increment,
  customer_id integer NOT NULL,
  address_id integer NOT NULL,
  created_at datetime NOT NULL,
  INDEX sales_order_headers_idx_address_id (address_id),
  INDEX sales_order_headers_idx_customer_id (customer_id),
  PRIMARY KEY (id),
  CONSTRAINT sales_order_headers_fk_address_id FOREIGN KEY (address_id) REFERENCES addresses (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT sales_order_headers_fk_customer_id FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS customer_addresses;

--
-- Table: customer_addresses
--
CREATE TABLE customer_addresses (
  id integer NOT NULL auto_increment,
  customer_id integer NOT NULL,
  address_id integer NOT NULL,
  type CHAR(4) NOT NULL,
  INDEX customer_addresses_idx_address_id (address_id),
  INDEX customer_addresses_idx_customer_id (customer_id),
  INDEX customer_addresses_idx_type (type),
  PRIMARY KEY (id),
  UNIQUE ui_customer_id_address_id_type (customer_id, address_id, type),
  CONSTRAINT customer_addresses_fk_address_id FOREIGN KEY (address_id) REFERENCES addresses (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT customer_addresses_fk_customer_id FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT customer_addresses_fk_type FOREIGN KEY (type) REFERENCES reference_address_types (type) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS sales_order_shipments;

--
-- Table: sales_order_shipments
--
CREATE TABLE sales_order_shipments (
  id integer NOT NULL auto_increment,
  order_header_id integer NOT NULL,
  address_id integer NOT NULL,
  INDEX sales_order_shipments_idx_order_header_id (order_header_id),
  INDEX sales_order_shipments_idx_address_id (address_id),
  PRIMARY KEY (id),
  CONSTRAINT sales_order_shipments_fk_order_header_id FOREIGN KEY (order_header_id) REFERENCES sales_order_headers (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT sales_order_shipments_fk_address_id FOREIGN KEY (address_id) REFERENCES addresses (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS sales_order_shipment_items;

--
-- Table: sales_order_shipment_items
--
CREATE TABLE sales_order_shipment_items (
  id integer NOT NULL auto_increment,
  shipment_id integer NOT NULL,
  product_id integer NOT NULL,
  quantity integer NOT NULL,
  INDEX sales_order_shipment_items_idx_shipment_id (shipment_id),
  PRIMARY KEY (id),
  CONSTRAINT sales_order_shipment_items_fk_shipment_id FOREIGN KEY (shipment_id) REFERENCES sales_order_shipments (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks=1;

