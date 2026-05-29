--
-- File generated with SQLiteStudio v3.4.4 on ke touko 8 19:40:09 2024
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: AssignedTo
CREATE TABLE IF NOT EXISTS AssignedTo (
    orderID TEXT,
    routeTimeID TEXT,
    PRIMARY KEY (orderID, routeTimeID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (routeTimeID) REFERENCES RouteTime(routeTimeID)
);

-- Table: CollectedBy
CREATE TABLE IF NOT EXISTS CollectedBy (
    orderID TEXT,
    collectorID TEXT,
    PRIMARY KEY (orderID, collectorID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (collectorID) REFERENCES Collectors(collectorID)
);
INSERT INTO CollectedBy (orderID, collectorID) VALUES ('O001', 'COL001');
INSERT INTO CollectedBy (orderID, collectorID) VALUES ('O002', 'COL002');

-- Table: Collectors
CREATE TABLE IF NOT EXISTS Collectors (
    collectorID TEXT PRIMARY KEY,
    name TEXT,
    phone TEXT,
    ordersPerHour INTEGER
);
INSERT INTO Collectors (collectorID, name, phone, ordersPerHour) VALUES ('COL001', 'Matti Meik‰l‰inen', '0441234567', 15);
INSERT INTO Collectors (collectorID, name, phone, ordersPerHour) VALUES ('COL002', 'Liisa Lahtinen', '0432345678', 20);

-- Table: Contains
CREATE TABLE IF NOT EXISTS Contains (
    productID INTEGER,
    rawMaterial TEXT,
    quantity REAL,
    PRIMARY KEY (productID, rawMaterial),
    FOREIGN KEY (productID) REFERENCES Products(productID),
    FOREIGN KEY (rawMaterial) REFERENCES RawMaterialsProduct(rawMaterial)
);

-- Table: CountInfo
CREATE TABLE IF NOT EXISTS CountInfo (
    orderID TEXT,
    productID TEXT,
    count INTEGER CHECK (count > 0) , 
    status TEXT,
    unit TEXT,
    PRIMARY KEY (orderID, productID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (productID) REFERENCES Products(productID)
);

-- Table: Customer
CREATE TABLE IF NOT EXISTS Customer (
    customerID TEXT PRIMARY KEY,
    phone TEXT, -- Puhelinnumerot voivat sis‰lt‰‰ kirjaimia ja erikoismerkkej‰
    address TEXT, -- Osoitteen voi tallentaa tekstimuodossa
    postalCode TEXT -- Postinumero voi sis‰lt‰‰ kirjaimia
);
INSERT INTO Customer (customerID, phone, address, postalCode) VALUES ('C001', '0501234567', 'Kalevankatu 10, Helsinki', '00100');
INSERT INTO Customer (customerID, phone, address, postalCode) VALUES ('C002', '0402345678', 'Pakkahuoneenaukio 2, Tampere', '33100');

-- Table: Included
CREATE TABLE IF NOT EXISTS Included (
packageID INTEGER,
    orderID TEXT,
    PRIMARY KEY (packageID, orderID),
    FOREIGN KEY (packageID) REFERENCES Package(packageID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

-- Table: IsCollected
CREATE TABLE IF NOT EXISTS IsCollected (
    timeSlotID TEXT,
    orderID TEXT,
    PRIMARY KEY (timeSlotID, orderID),
    FOREIGN KEY (timeSlotID) REFERENCES TimeSlots(timeSlotID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);
INSERT INTO IsCollected (timeSlotID, orderID) VALUES ('TS001', 'O001');
INSERT INTO IsCollected (timeSlotID, orderID) VALUES ('TS002', 'O002');

-- Table: IsWorking
CREATE TABLE IF NOT EXISTS IsWorking (
    timeSlotID TEXT,
    collectorID TEXT,
    PRIMARY KEY (timeSlotID, collectorID),
    FOREIGN KEY (timeSlotID) REFERENCES TimeSlots(timeSlotID),
    FOREIGN KEY (collectorID) REFERENCES Collectors(collectorID)
);

-- Table: LocatedAt
CREATE TABLE IF NOT EXISTS LocatedAt (
    routeID TEXT,
    postalCode TEXT,
    PRIMARY KEY (routeID, postalCode),
    FOREIGN KEY (routeID) REFERENCES Routes(routeID),
    FOREIGN KEY (postalCode) REFERENCES postalCodeAreas(postalCode)
);

-- Table: Operates
CREATE TABLE IF NOT EXISTS Operates (
    routeID TEXT,
    routeTimeID TEXT,
    PRIMARY KEY (routeID, routeTimeID),
    FOREIGN KEY (routeID) REFERENCES Routes(routeID),
    FOREIGN KEY (routeTimeID) REFERENCES RouteTime(routeTimeID)
);

-- Table: Orders
CREATE TABLE IF NOT EXISTS Orders (
    orderID TEXT PRIMARY KEY,
    customerID TEXT, 
    orderDate DATE, -- P‰iv‰m‰‰r‰t tallennetaan DATE-muodossa
    deliveryDate DATE, 
    replacement TEXT,
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);
INSERT INTO Orders (orderID, customerID, orderDate, deliveryDate, replacement) VALUES ('O001', 'C001', '2024-05-01', '2024-05-02', 'Yes');
INSERT INTO Orders (orderID, customerID, orderDate, deliveryDate, replacement) VALUES ('O002', 'C002', '2024-05-01', '2024-05-02', 'No');

-- Table: Package
CREATE TABLE IF NOT EXISTS Package (
    packageID INTEGER PRIMARY KEY,
    storage TEXT
);

-- Table: Places
CREATE TABLE IF NOT EXISTS Places (
    customerID TEXT,
    orderID TEXT,
    PRIMARY KEY (customerID, orderID),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);
INSERT INTO Places (customerID, orderID) VALUES ('C001', 'O001');
INSERT INTO Places (customerID, orderID) VALUES ('C002', 'O002');

-- Table: PlacesProduct
CREATE TABLE IF NOT EXISTS PlacesProduct (
    orderID TEXT,
    productID INTEGER,
    PRIMARY KEY (orderID, productID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (productID) REFERENCES Products(productID)
);

-- Table: postalCodeAreas
CREATE TABLE IF NOT EXISTS postalCodeAreas (
    postalCode TEXT PRIMARY KEY
);

-- Table: Priced
CREATE TABLE IF NOT EXISTS Priced (
    priceID INTEGER,
    productID INTEGER,
    PRIMARY KEY (priceID, productID),
    FOREIGN KEY (priceID) REFERENCES ProductPrice(priceID),
    FOREIGN KEY (productID) REFERENCES Products(productID)
);

-- Table: ProductPrice
CREATE TABLE IF NOT EXISTS ProductPrice (
    priceID INTEGER PRIMARY KEY,
    discount REAL,
    validity TEXT
);

-- Table: Products
CREATE TABLE IF NOT EXISTS Products (
    productID INTEGER PRIMARY KEY,
    name TEXT,
    size TEXT,
    energy REAL, -- Energia voi olla desimaaliluku, k‰yt‰n REAL-muotoa
    fat REAL,
    carbohydrates REAL,
    proteins REAL
);
INSERT INTO Products (productID, name, size, energy, fat, carbohydrates, proteins) VALUES (1, 'Maito', '1L', 42.0, 0.5, 4.7, 3.4);
INSERT INTO Products (productID, name, size, energy, fat, carbohydrates, proteins) VALUES (2, 'Leip‰', '500g', 250.0, 2.0, 50.0, 9.0);

-- Table: RawMaterialsProduct
CREATE TABLE IF NOT EXISTS RawMaterialsProduct (
    rawMaterial TEXT,
    quantity REAL,
    productID INTEGER,
    FOREIGN KEY (productID) REFERENCES Products(productID),
    PRIMARY KEY (rawMaterial)
);
INSERT INTO RawMaterialsProduct (rawMaterial, quantity, productID) VALUES ('Sokeri', 10.0, 1);
INSERT INTO RawMaterialsProduct (rawMaterial, quantity, productID) VALUES ('Jauho', 20.0, 2);

-- Table: ReplaceableBy
CREATE TABLE IF NOT EXISTS ReplaceableBy (
    productID INTEGER,
    replaceableByProductID INTEGER,
    PRIMARY KEY (productID, replaceableByProductID),
    FOREIGN KEY (productID) REFERENCES Products(productID),
    FOREIGN KEY (replaceableByProductID) REFERENCES Products(productID)
);

-- Table: Replaces
CREATE TABLE IF NOT EXISTS Replaces (
    orderID TEXT,
    replacementID TEXT,
    PRIMARY KEY (orderID, replacementID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (replacementID) REFERENCES Replacement(replacementID)
);

-- Table: RouteOrders
CREATE TABLE IF NOT EXISTS RouteOrders (
    routeID TEXT,
    startTime TIME,
    weekday TEXT,
    endTime TIME,
    FOREIGN KEY (routeID) REFERENCES Routes(routeID),
    PRIMARY KEY (routeID, startTime, weekday)
);

-- Table: Routes
CREATE TABLE IF NOT EXISTS Routes (
    routeID TEXT PRIMARY KEY,
    maxOrders INTEGER
);
INSERT INTO Routes (routeID, maxOrders) VALUES ('R001', 10);
INSERT INTO Routes (routeID, maxOrders) VALUES ('R002', 20);

-- Table: RouteTime
CREATE TABLE IF NOT EXISTS RouteTime (
    routeTimeID TEXT,
    routeID TEXT,
    startTime TIME,
    endTime TIME,
    FOREIGN KEY (routeID) REFERENCES Routes(routeID),
    PRIMARY KEY (routeID, startTime)
);

-- Table: SetAt
CREATE TABLE IF NOT EXISTS SetAt (
    routeID TEXT,
    orderID TEXT,
    PRIMARY KEY (routeID, orderID),
    FOREIGN KEY (routeID) REFERENCES Routes(routeID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

-- Table: SpecialDiets
CREATE TABLE IF NOT EXISTS SpecialDiets (
    name TEXT PRIMARY KEY
);
INSERT INTO SpecialDiets (name) VALUES ('Gluteeniton');
INSERT INTO SpecialDiets (name) VALUES ('Vegaani');

-- Table: Stocks
CREATE TABLE IF NOT EXISTS Stocks (
    storeID TEXT,
    productID INTEGER,
    PRIMARY KEY (storeID, productID),
    FOREIGN KEY (storeID) REFERENCES Stores(storeID),
    FOREIGN KEY (productID) REFERENCES Products(productID)
);

-- Table: Stores
CREATE TABLE IF NOT EXISTS Stores (
    storeID TEXT PRIMARY KEY,
    phone TEXT
);

-- Table: TimeSlots
CREATE TABLE IF NOT EXISTS TimeSlots (
    timeSlotID TEXT PRIMARY KEY,
    collectionDate TIME, -- Aikaleimat tallennetaan TIME-muodossa
    startTime TIME, -- Aikaleimat tallennetaan TIME-muodossa
    duration INTEGER --Aikaleiman pituus
);
INSERT INTO TimeSlots (timeSlotID, collectionDate, startTime, duration) VALUES ('TS001', '08:00:00', '08:00:00', 30);
INSERT INTO TimeSlots (timeSlotID, collectionDate, startTime, duration) VALUES ('TS002', '09:00:00', '09:00:00', 30);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
