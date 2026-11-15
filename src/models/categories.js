import db from './db.js'

const getAllCategories = async() => {
    const query = `
        SELECT category_id, name
        FROM category
        ORDER BY name ASC;
    `;
    const result = await db.query(query);
    return result.rows;
}

// NEW: single category by ID
const getCategoryDetails = async (categoryId) => {
    const query = `
        SELECT category_id, name
        FROM category
        WHERE category_id = $1;
    `;

    const queryParams = [categoryId];
    const result = await db.query(query, queryParams);

    return result.rows.length > 0 ? result.rows[0] : null;
};

// NEW: all categories for a given service project
const getCategoriesByProjectId = async (projectId) => {
    const query = `
        SELECT
            c.category_id,
            c.name
        FROM category c
        JOIN service_project_category spc
            ON c.category_id = spc.category_id
        WHERE spc.project_id = $1
        ORDER BY c.name ASC;
    `;

    const queryParams = [projectId];
    const result = await db.query(query, queryParams);
    return result.rows;
};

const assignCategoryToProject = async (projectId, categoryId) => {
    const query = `
        INSERT INTO service_project_category (project_id, category_id)
        VALUES ($1, $2)
        ON CONFLICT (project_id, category_id) DO NOTHING;
    `;

    await db.query(query, [projectId, categoryId]);
}

const updateCategoryAssignments = async (projectId, categoryIds) => {
    // First, remove existing category assignments for the project
    const deleteQuery = `
        DELETE FROM service_project_category
        WHERE project_id = $1;
    `;
    await db.query(deleteQuery, [projectId]);

    // Next, add the new category assignments
    for (const categoryId of categoryIds) {
        await assignCategoryToProject(projectId, categoryId);
    }
}

const createCategory = async (name) => {
    const query = `
      INSERT INTO category (name)
      VALUES ($1)
      RETURNING category_id;
    `;

    const queryParams = [name];
    const result = await db.query(query, queryParams);

    if (result.rows.length === 0) {
        throw new Error('Failed to create category');
    }

    if (process.env.ENABLE_SQL_LOGGING === 'true') {
        console.log('Created new category with ID:', result.rows[0].category_id);
    }

    return result.rows[0].category_id;
};

const updateCategory = async (categoryId, name) => {
    const query = `
      UPDATE category
      SET name = $1
      WHERE category_id = $2
      RETURNING category_id;
    `;

    const queryParams = [name, categoryId];
    const result = await db.query(query, queryParams);

    if (result.rows.length === 0) {
        throw new Error('Category not found');
    }

    if (process.env.ENABLE_SQL_LOGGING === 'true') {
        console.log('Updated category with ID:', categoryId);
    }

    return result.rows[0].category_id;
};

export { getAllCategories, getCategoryDetails, getCategoriesByProjectId, updateCategoryAssignments, createCategory, updateCategory }