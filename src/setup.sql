-- Drop existing tables in correct order (child first)
DROP TABLE IF EXISTS service_project_category;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS service_project;
DROP TABLE IF EXISTS organization;

-- ========================================
-- Organization Table
-- ========================================
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

-- ========================================
-- Service Project Table
-- ========================================
CREATE TABLE service_project (
    project_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(200) NOT NULL,
    date DATE NOT NULL,
    CONSTRAINT fk_organization
        FOREIGN KEY (organization_id)
        REFERENCES organization(organization_id)
        ON DELETE CASCADE
);

-- ========================================
-- Category Table
-- ========================================
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- ========================================
-- Service Project Category Table (Junction)
-- ========================================
CREATE TABLE service_project_category (
    project_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    PRIMARY KEY (project_id, category_id),
    CONSTRAINT fk_project
        FOREIGN KEY (project_id)
        REFERENCES service_project(project_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
        ON DELETE CASCADE
);

-- ========================================
-- Insert sample data: Organizations
-- ========================================
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

-- ========================================
-- Insert sample data: Service Projects (5 per org = 15)
-- ========================================
-- For BrightFuture Builders (org_id 1)
INSERT INTO service_project (organization_id, title, description, location, date) VALUES
(1, 'Park Shelter Build', 'Help construct a new community shelter at Riverside Park.', 'Riverside Park, Provo', '2026-05-15'),
(1, 'School Ramp Installation', 'Install accessibility ramps at local elementary school.', 'Sunset Elementary', '2026-06-02'),
(1, 'Habitat Home Repair', 'Repair roofs and porches for low-income families.', 'West Provo Neighborhood', '2026-06-20'),
(1, 'Trail Bridge Restoration', 'Restore wooden bridge on community hiking trail.', 'Y Mountain Trail', '2026-07-10'),
(1, 'Community Center Painting', 'Paint interior of new community center.', 'Provo Community Center', '2026-07-25');

-- For GreenHarvest Growers (org_id 2)
INSERT INTO service_project (organization_id, title, description, location, date) VALUES
(2, 'Spring Community Garden Planting', 'Plant vegetables for the summer harvest season.', 'Downtown Community Garden', '2026-04-10'),
(2, 'Urban Orchard Maintenance', 'Prune fruit trees and clear weeds in urban orchard.', 'GreenHarvest Orchard Lot', '2026-05-01'),
(2, 'Composting Workshop', 'Teach families how to compost food waste at home.', 'Provo Library', '2026-05-22'),
(2, 'Food Bank Harvest Delivery', 'Harvest and deliver fresh produce to food bank.', 'Utah Food Bank', '2026-08-15'),
(2, 'School Garden Build', 'Build raised beds for school gardening program.', 'Franklin Elementary', '2026-09-05');

-- For UnityServe Volunteers (org_id 3)
INSERT INTO service_project (organization_id, title, description, location, date) VALUES
(3, 'Neighborhood Park Cleanup', 'Join us to clean up local parks and make them beautiful.', 'Paul Ream Wilderness Park', '2026-04-18'),
(3, 'Senior Center Tech Help', 'Help seniors learn to use smartphones and video calls.', 'Provo Senior Center', '2026-05-08'),
(3, 'Food Drive Collection', 'Collect and sort canned goods for families in need.', 'Smith''s Marketplace Parking Lot', '2026-06-12'),
(3, 'Community Tutoring Night', 'Volunteer to tutor students in math and reading.', 'Provo Public Library', '2026-06-28'),
(3, 'Winter Clothing Drive', 'Sort and distribute coats and blankets.', 'UnityServe Warehouse', '2026-11-10');

-- ========================================
-- Insert sample data: Categories
-- ========================================
INSERT INTO category (name) VALUES
('Environmental'),
('Educational'),
('Community Service'),
('Health and Wellness');

-- ========================================
-- Insert sample data: Service Project Categories
-- ========================================
-- Each project gets at least one category
INSERT INTO service_project_category (project_id, category_id) VALUES
(1, 3), (1, 1),
(2, 3), (2, 4),
(3, 3),
(4, 1), (4, 3),
(5, 3),
(6, 1), (6, 3),
(7, 1), (7, 3),
(8, 1), (8, 2),
(9, 1), (9, 3),
(10, 2), (10, 1),
(11, 1), (11, 3),
(12, 2), (12, 3),
(13, 3), (13, 4),
(14, 2), (14, 3),
(15, 3), (15, 4);

-- Verify insert
-- SELECT * FROM service_project;
-- SELECT * FROM category;
-- SELECT * FROM service_project_category;