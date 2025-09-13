// tests/helpers/test-setup.js
// Common test setup and configuration

import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load test environment variables
dotenv.config({ path: path.join(__dirname, '../../.env.test') });

// Global test configuration
export const testConfig = {
    timeout: 10000,
    slow: 500,
    database: {
        host: process.env.DB_HOST || 'localhost',
        port: process.env.DB_PORT || 3306,
        name: process.env.DB_NAME || 'test_db',
        user: process.env.DB_USER || 'test_user',
        password: process.env.DB_PASSWORD || 'test_password'
    }
};

// JWT token generator for testing
import jwt from 'jsonwebtoken';

export function generateTestToken(userId, expiresIn = '1h') {
    return jwt.sign(
        { userId, type: 'test' },
        process.env.JWT_SECRET || 'test_secret',
        { expiresIn }
    );
}

// Database connection helper
export async function waitForDatabase(db, maxAttempts = 30) {
    for (let i = 0; i < maxAttempts; i++) {
        try {
            await db.sequelize.authenticate();
            console.log('Database connected successfully');
            return true;
        } catch (error) {
            console.log(`Waiting for database... attempt ${i + 1}/${maxAttempts}`);
            await new Promise(resolve => setTimeout(resolve, 1000));
        }
    }
    throw new Error('Could not connect to database');
}

// Console output suppression for tests
export function suppressConsole() {
    const originalConsole = {
        log: console.log,
        error: console.error,
        warn: console.warn,
        info: console.info
    };
    
    before(() => {
        if (process.env.TEST_VERBOSE !== 'true') {
            console.log = () => {};
            console.error = () => {};
            console.warn = () => {};
            console.info = () => {};
        }
    });
    
    after(() => {
        console.log = originalConsole.log;
        console.error = originalConsole.error;
        console.warn = originalConsole.warn;
        console.info = originalConsole.info;
    });
    
    return originalConsole;
}

// Test transaction wrapper
export async function withTransaction(db, callback) {
    const transaction = await db.sequelize.transaction();
    try {
        const result = await callback(transaction);
        await transaction.commit();
        return result;
    } catch (error) {
        await transaction.rollback();
        throw error;
    }
}

// Assertion helpers
export const expectError = (fn, errorMessage) => {
    let error = null;
    try {
        fn();
    } catch (e) {
        error = e;
    }
    expect(error).to.not.be.null;
    if (errorMessage) {
        expect(error.message).to.include(errorMessage);
    }
    return error;
};

export const expectAsyncError = async (fn, errorMessage) => {
    let error = null;
    try {
        await fn();
    } catch (e) {
        error = e;
    }
    expect(error).to.not.be.null;
    if (errorMessage) {
        expect(error.message).to.include(errorMessage);
    }
    return error;
};

// Deep equality helper for database objects
export function expectDeepEqual(actual, expected, excludeFields = ['createdAt', 'updatedAt']) {
    const cleanObject = (obj) => {
        const cleaned = { ...obj };
        excludeFields.forEach(field => delete cleaned[field]);
        return cleaned;
    };
    
    const actualCleaned = cleanObject(actual.toJSON ? actual.toJSON() : actual);
    const expectedCleaned = cleanObject(expected);
    
    expect(actualCleaned).to.deep.equal(expectedCleaned);
}

export default {
    testConfig,
    generateTestToken,
    waitForDatabase,
    suppressConsole,
    withTransaction,
    expectError,
    expectAsyncError,
    expectDeepEqual
};