// tests/helpers/test-factory.js
// Factory functions for creating test data

import bcrypt from 'bcrypt';

let userCounter = 0;
let courseCounter = 0;

export class TestFactory {
    // User creation helpers
    static async createStudent(db, overrides = {}) {
        userCounter++;
        const defaultData = {
            email: `student${userCounter}_${Date.now()}@test.com`,
            first_name: 'Test',
            last_name: `Student${userCounter}`,
            user_type: 's',
            program_id: 1,
            password: await bcrypt.hash('testpassword', 10)
        };
        
        return await db.User.create({ ...defaultData, ...overrides });
    }
    
    static async createInstructor(db, overrides = {}) {
        userCounter++;
        const defaultData = {
            email: `instructor${userCounter}_${Date.now()}@test.com`,
            first_name: 'Test',
            last_name: `Instructor${userCounter}`,
            user_type: 'i',
            password: await bcrypt.hash('testpassword', 10)
        };
        
        return await db.User.create({ ...defaultData, ...overrides });
    }
    
    // Course creation helpers
    static async createCourse(db, overrides = {}) {
        courseCounter++;
        const defaultData = {
            name: `Test Course ${courseCounter}`,
            code: `TEST${courseCounter}${Date.now()}`.substring(0, 20),
            competency_units: 3,
            assessment_type: 'Mixed',
            description: 'Test course description',
            is_active: true
        };
        
        return await db.Course.create({ ...defaultData, ...overrides });
    }
    
    // Term creation helper
    static async createTerm(db, studentId, overrides = {}) {
        const defaultData = {
            term_no: 1,
            startDate: new Date('2024-01-01'),
            endDate: new Date('2024-06-30'),
            student_id: studentId
        };
        
        return await db.Term.create({ ...defaultData, ...overrides });
    }
    
    // Enrollment creation helper
    static async createEnrollment(db, student, course, instructor, overrides = {}) {
        const defaultData = {
            userId: student.id,
            courseId: course.id,
            instructorId: instructor.id,
            startDate: new Date(),
            status: 'a'
        };
        
        return await db.StudentCourse.create({ ...defaultData, ...overrides });
    }
    
    // Assessment creation helper
    static async createAssessment(db, courseId, overrides = {}) {
        const defaultData = {
            course_id: courseId,
            name: 'Test Assessment',
            type: 'O',
            description: 'Test assessment description',
            passing_score: 70.00,
            max_attempts: 3,
            time_limit_minutes: 60,
            is_proctored: false,
            is_required_to_pass: true,
            sequence_order: 1,
            is_active: true
        };
        
        return await db.Assessment.create({ ...defaultData, ...overrides });
    }
    
    // Complete test scenario creation
    static async createTestScenario(db) {
        const instructor = await this.createInstructor(db);
        const student = await this.createStudent(db);
        const course = await this.createCourse(db);
        const term = await this.createTerm(db, student.id);
        const enrollment = await this.createEnrollment(db, student, course, instructor, {
            term_id: term.id
        });
        
        return {
            instructor,
            student,
            course,
            term,
            enrollment
        };
    }
    
    // Cleanup helper
    static async cleanup(db) {
        // Delete in correct order to avoid foreign key constraints
        await db.StudentAssessment.destroy({ where: {}, force: true });
        await db.StudentCourse.destroy({ where: {}, force: true });
        await db.Assessment.destroy({ where: {}, force: true });
        await db.Term.destroy({ where: {}, force: true });
        await db.ProgramCourse.destroy({ where: {}, force: true });
        await db.Course.destroy({ where: {}, force: true });
        await db.User.destroy({ where: {}, force: true });
        await db.Program.destroy({ where: {}, force: true });
        await db.College.destroy({ where: {}, force: true });
        
        // Reset counters
        userCounter = 0;
        courseCounter = 0;
    }
    
    // Seed reference data
    static async seedReferenceData(db) {
        // Create colleges
        const colleges = await db.College.bulkCreate([
            { id: 1, name: 'College of IT', code: 'IT', description: 'Information Technology' },
            { id: 2, name: 'College of Business', code: 'BUS', description: 'Business Administration' }
        ]);
        
        // Create programs
        const programs = await db.Program.bulkCreate([
            {
                id: 1,
                name: 'Computer Science',
                code: 'CS',
                degree_level: 'Bachelor',
                college_id: 1,
                total_competency_units: 120,
                tuition_per_term: 3500.00,
                is_active: true
            },
            {
                id: 2,
                name: 'Business Administration',
                code: 'BA',
                degree_level: 'Bachelor',
                college_id: 2,
                total_competency_units: 120,
                tuition_per_term: 3200.00,
                is_active: true
            }
        ]);
        
        return { colleges, programs };
    }
}

// Export convenience functions
export const createStudent = (db, overrides) => TestFactory.createStudent(db, overrides);
export const createInstructor = (db, overrides) => TestFactory.createInstructor(db, overrides);
export const createCourse = (db, overrides) => TestFactory.createCourse(db, overrides);
export const createEnrollment = (db, ...args) => TestFactory.createEnrollment(db, ...args);
export const cleanup = (db) => TestFactory.cleanup(db);

export default TestFactory;