DROP TABLE IF EXISTS participated;
DROP TABLE IF EXISTS owns;
DROP TABLE IF EXISTS accident;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS person;

CREATE TABLE person (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
);

CREATE TABLE car (
    license_plate VARCHAR(20) PRIMARY KEY,
    model VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    CONSTRAINT chk_year CHECK (year >= 1900 AND year <= YEAR(CURDATE()))
);

CREATE TABLE accident (
    report_number INT PRIMARY KEY AUTO_INCREMENT,
    year INT NOT NULL,
    location VARCHAR(255) NOT NULL,
    CONSTRAINT chk_accident_year CHECK (year >= 1900 AND year <= YEAR(CURDATE()))
);

CREATE TABLE owns (
    driver_id INT NOT NULL,
    license_plate VARCHAR(20) NOT NULL,
    PRIMARY KEY (driver_id, license_plate),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (license_plate) REFERENCES car(license_plate) ON DELETE CASCADE
);

CREATE TABLE participated (
    report_number INT NOT NULL,
    license_plate VARCHAR(20) NOT NULL,
    driver_id INT NOT NULL,
    damage_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (report_number, license_plate, driver_id),
    FOREIGN KEY (report_number) REFERENCES accident(report_number) ON DELETE CASCADE,
    FOREIGN KEY (license_plate) REFERENCES car(license_plate) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON DELETE CASCADE,
    CONSTRAINT chk_damage_amount CHECK (damage_amount >= 0)
);

ALTER TABLE person ADD COLUMN address VARCHAR(225) NOT NULL;
