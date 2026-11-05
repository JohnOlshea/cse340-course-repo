import db from './db.js'

/**
 * Get all service projects with their organization names
 * Requires a JOIN between service_project and organization
 */
const getAllProjects = async() => {
    const query = `
        SELECT 
            p.project_id,
            p.organization_id,
            p.title,
            p.description,
            p.location,
            p.date,
            o.name AS organization_name
        FROM service_project p
        JOIN organization o ON p.organization_id = o.organization_id
        ORDER BY p.date ASC;
    `;

    const result = await db.query(query);
    return result.rows;
}

export { getAllProjects }