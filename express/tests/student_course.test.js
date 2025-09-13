// tests/student_course-esmock.test.js
import { expect } from 'chai';
import request from 'supertest';
import express from 'express';
import sinon from 'sinon';
import esmock from 'esmock';
import { Op } from 'sequelize';

describe('Student Course Routes with ESMock', () => {
    let app;
    let router;
    let mockDb;
    let mockAuthenticate;
    
    beforeEach(async () => {
        // Create mock database
        mockDb = {
            sequelize: {
                transaction: sinon.stub(),
                random: sinon.stub().returns('RANDOM()')
            },
            StudentCourse: {
                findAll: sinon.stub(),
                findOne: sinon.stub(),
                findByPk: sinon.stub(),
                create: sinon.stub(),
                destroy: sinon.stub()
            },
            User: {
                findByPk: sinon.stub(),
                findOne: sinon.stub()
            },
            Course: {
                findByPk: sinon.stub()
            },
            ProgramCourse: {
                findAll: sinon.stub()
            },
            Assessment: {
                findAll: sinon.stub()
            },
            StudentAssessment: {
                findAll: sinon.stub(),
                create: sinon.stub(),
                bulkCreate: sinon.stub(),
                destroy: sinon.stub()
            },
            Term: {}
        };
        
        // Mock transaction function to work with the withTransaction helper
        const mockTransaction = {
            commit: sinon.stub().resolves(),
            rollback: sinon.stub().resolves()
        };
        
        mockDb.sequelize.transaction.callsFake(async (callback) => {
            if (callback) {
                return await callback(mockTransaction);
            }
            return mockTransaction;
        });
        
        // Mock authenticate middleware
        mockAuthenticate = sinon.stub().callsFake((req, res, next) => {
            req.userId = 1;
            next();
        });
        
        // Use esmock to import the route with mocked dependencies
        router = await esmock('../routes/student_course.js', {
            '../models/index.js': {
                default: () => mockDb
            },
            '../middleware/authenticate.js': {
                default: mockAuthenticate
            }
        });
        
        // Create Express app with mocked router
        app = express();
        app.use(express.json());
        app.use('/student_course', router);
    });
    
    afterEach(() => {
        sinon.restore();
    });
    
    describe('GET /student_course', () => {
        it('should return all student courses', async () => {
            const mockCourses = [
                { id: 1, userId: 1, courseId: 101, status: 'a' },
                { id: 2, userId: 1, courseId: 102, status: 'c' }
            ];
            
            mockDb.StudentCourse.findAll.resolves(mockCourses);
            
            const response = await request(app)
                .get('/student_course')
                .expect(200);
            
            expect(response.body).to.deep.equal(mockCourses);
            
            // Verify the query was called correctly
            const callArgs = mockDb.StudentCourse.findAll.firstCall.args[0];
            expect(callArgs.where.userId).to.equal(1);
            expect(callArgs.order).to.deep.equal([['startDate', 'DESC']]);
        });
        
        it('should filter by status', async () => {
            mockDb.StudentCourse.findAll.resolves([]);
            
            await request(app)
                .get('/student_course?status=a')
                .expect(200);
            
            const callArgs = mockDb.StudentCourse.findAll.firstCall.args[0];
            expect(callArgs.where.status).to.equal('a');
            expect(callArgs.where.userId).to.equal(1);
        });
        
        it('should include course data when requested', async () => {
            mockDb.StudentCourse.findAll.resolves([]);
            
            await request(app)
                .get('/student_course?include_course=true')
                .expect(200);
            
            const callArgs = mockDb.StudentCourse.findAll.firstCall.args[0];
            expect(callArgs.include).to.be.an('array');
            const courseInclude = callArgs.include.find(inc => inc.model === mockDb.Course);
            expect(courseInclude).to.exist;
            expect(courseInclude.as).to.equal('Course');
        });
        
        it('should return 400 for invalid status', async () => {
            const response = await request(app)
                .get('/student_course?status=invalid')
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.include('Invalid status');
        });
        
        it('should handle database errors', async () => {
            mockDb.StudentCourse.findAll.rejects(new Error('Database error'));
            
            const response = await request(app)
                .get('/student_course')
                .expect(500);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Error fetching student courses');
        });
    });
    
    describe('GET /student_course/upcomming', () => {
        it('should return upcoming courses', async () => {
            const mockUser = {
                id: 1,
                program_id: 1,
                toJSON: () => ({ program_id: 1 })
            };
            
            const mockProgramCourses = [
                {
                    id: 1,
                    program_id: 1,
                    course: { id: 102, name: 'Math 102', code: 'MATH102' },
                    toJSON: () => ({
                        program_id: 1,
                        course: { id: 102, name: 'Math 102', code: 'MATH102' }
                    })
                }
            ];
            
            mockDb.User.findByPk.resolves(mockUser);
            mockDb.StudentCourse.findAll.resolves([]);
            mockDb.ProgramCourse.findAll.resolves(mockProgramCourses);
            
            const response = await request(app)
                .get('/student_course/upcomming')
                .expect(200);
            
            expect(response.body).to.be.an('array');
            expect(response.body[0]).to.have.property('id', 102);
            expect(response.body[0]).to.have.property('program_id', 1);
        });
        
        it('should return 404 when user not found', async () => {
            mockDb.User.findByPk.resolves(null);
            
            const response = await request(app)
                .get('/student_course/upcomming')
                .expect(404);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('User not found');
        });
        
        it('should return 400 when user has no program', async () => {
            const mockUser = {
                id: 1,
                program_id: null,
                toJSON: () => ({ program_id: null })
            };
            
            mockDb.User.findByPk.resolves(mockUser);
            
            const response = await request(app)
                .get('/student_course/upcomming')
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('User is not enrolled in a program');
        });
        
        it('should exclude already enrolled courses', async () => {
            const mockUser = {
                id: 1,
                program_id: 1,
                toJSON: () => ({ program_id: 1 })
            };
            
            mockDb.User.findByPk.resolves(mockUser);
            mockDb.StudentCourse.findAll.resolves([
                { courseId: 101 },
                { courseId: 102 }
            ]);
            mockDb.ProgramCourse.findAll.resolves([]);
            
            await request(app)
                .get('/student_course/upcomming')
                .expect(200);
            
            // Verify the enrolled courses query
            const enrolledCoursesQuery = mockDb.StudentCourse.findAll.firstCall.args[0];
            expect(enrolledCoursesQuery.where.status).to.have.property(Op.in);
            expect(enrolledCoursesQuery.where.status[Op.in]).to.deep.equal(['c', 'a']);
            
            // Verify the program courses query excludes enrolled courses
            const callArgs = mockDb.ProgramCourse.findAll.firstCall.args[0];
            expect(callArgs.where.course_id).to.have.property(Op.notIn);
            expect(callArgs.where.course_id[Op.notIn]).to.deep.equal([101, 102]);
        });
    });
    
    describe('GET /student_course/:id', () => {
        it('should return specific student course', async () => {
            const mockStudentCourse = {
                id: 1,
                userId: 1,
                courseId: 101,
                status: 'a',
                Course: { id: 101, name: 'Math 101' }
            };
            
            mockDb.StudentCourse.findOne.resolves(mockStudentCourse);
            
            const response = await request(app)
                .get('/student_course/1')
                .expect(200);
            
            expect(response.body).to.deep.equal(mockStudentCourse);
            
            const callArgs = mockDb.StudentCourse.findOne.firstCall.args[0];
            expect(callArgs.where.id).to.equal(1);
            expect(callArgs.where.userId).to.equal(1);
        });
        
        it('should return 404 when student course not found', async () => {
            mockDb.StudentCourse.findOne.resolves(null);
            
            const response = await request(app)
                .get('/student_course/999')
                .expect(404);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Student course not found');
        });
        
        it('should return 400 for invalid ID', async () => {
            const response = await request(app)
                .get('/student_course/invalid')
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.include('Invalid student course ID');
        });
    });
    
    describe('GET /student_course/course/:courseId', () => {
        it('should return student course by course ID', async () => {
            const mockStudentCourse = {
                id: 1,
                userId: 1,
                courseId: 101,
                status: 'a'
            };
            
            mockDb.StudentCourse.findOne.resolves(mockStudentCourse);
            
            const response = await request(app)
                .get('/student_course/course/101')
                .expect(200);
            
            expect(response.body).to.deep.equal(mockStudentCourse);
            
            const callArgs = mockDb.StudentCourse.findOne.firstCall.args[0];
            expect(callArgs.where.courseId).to.equal(101);
            expect(callArgs.where.userId).to.equal(1);
        });
        
        it('should return 404 when enrollment not found', async () => {
            mockDb.StudentCourse.findOne.resolves(null);
            
            const response = await request(app)
                .get('/student_course/course/999')
                .expect(404);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Student course enrollment not found');
        });
    });
    
    describe('GET /student_course/status/:status', () => {
        it('should return courses by status', async () => {
            const mockCourses = [
                { id: 1, status: 'a', courseId: 101 },
                { id: 2, status: 'a', courseId: 102 }
            ];
            
            mockDb.StudentCourse.findAll.resolves(mockCourses);
            
            const response = await request(app)
                .get('/student_course/status/a')
                .expect(200);
            
            expect(response.body).to.deep.equal(mockCourses);
            
            const callArgs = mockDb.StudentCourse.findAll.firstCall.args[0];
            expect(callArgs.where.status).to.equal('a');
            expect(callArgs.where.userId).to.equal(1);
        });
        
        it('should return 400 for invalid status', async () => {
            const response = await request(app)
                .get('/student_course/status/invalid')
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.include('Invalid status');
        });
    });
    
    describe('GET /student_course/term/:termId', () => {
        it('should return courses by term', async () => {
            const mockCourses = [
                { id: 1, term_id: 1, courseId: 101 },
                { id: 2, term_id: 1, courseId: 102 }
            ];
            
            mockDb.StudentCourse.findAll.resolves(mockCourses);
            
            const response = await request(app)
                .get('/student_course/term/1')
                .expect(200);
            
            expect(response.body).to.deep.equal(mockCourses);
            
            const callArgs = mockDb.StudentCourse.findAll.firstCall.args[0];
            expect(callArgs.where.term_id).to.equal(1);
            expect(callArgs.where.userId).to.equal(1);
            expect(callArgs.order).to.deep.equal([['startDate', 'ASC']]);
        });
    });
    
    describe('POST /student_course', () => {
        it('should create new enrollment', async () => {
            const mockCourse = { id: 101, name: 'Math 101' };
            const mockInstructor = { id: 2, user_type: 'i' };
            const mockStudentCourse = {
                id: 1,
                userId: 1,
                courseId: 101,
                instructorId: 2,
                status: 'i'
            };
            
            // Mock the transaction callback to return the created student course
            const mockTransaction = {
                commit: sinon.stub().resolves(),
                rollback: sinon.stub().resolves()
            };
            
            mockDb.sequelize.transaction.callsFake(async (callback) => {
                if (callback) {
                    return await callback(mockTransaction);
                }
                return mockTransaction;
            });
            
            mockDb.Course.findByPk.resolves(mockCourse);
            mockDb.StudentCourse.findOne.resolves(null); // No existing enrollment
            mockDb.User.findOne.resolves(mockInstructor);
            mockDb.StudentCourse.create.resolves(mockStudentCourse);
            mockDb.Assessment.findAll.resolves([]);
            mockDb.StudentAssessment.bulkCreate.resolves([]);
            
            const response = await request(app)
                .post('/student_course')
                .send({ courseId: 101 })
                .expect(201);
            
            expect(response.body).to.deep.equal(mockStudentCourse);
            
            // Verify course lookup
            expect(mockDb.Course.findByPk.calledWith(101)).to.be.true;
            
            // Verify enrollment check
            const findOneArgs = mockDb.StudentCourse.findOne.firstCall.args[0];
            expect(findOneArgs.where.userId).to.equal(1);
            expect(findOneArgs.where.courseId).to.equal(101);
            expect(findOneArgs.where.status).to.have.property(Op.in);
            expect(findOneArgs.where.status[Op.in]).to.deep.equal(['a', 'i']);
        });
        
        it('should return 400 when courseId missing', async () => {
            const response = await request(app)
                .post('/student_course')
                .send({})
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Course ID is required');
        });
        
        it('should return 404 when course not found', async () => {
            mockDb.Course.findByPk.resolves(null);
            
            const response = await request(app)
                .post('/student_course')
                .send({ courseId: 999 })
                .expect(404);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Course not found');
        });
        
        it('should return 409 when already enrolled', async () => {
            const mockCourse = { id: 101, name: 'Math 101' };
            const existingEnrollment = { id: 1, userId: 1, courseId: 101, status: 'a' };
            
            mockDb.Course.findByPk.resolves(mockCourse);
            mockDb.StudentCourse.findOne.resolves(existingEnrollment);
            
            const response = await request(app)
                .post('/student_course')
                .send({ courseId: 101 })
                .expect(409);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Already enrolled in this course');
            
            // Verify the query checked for active and in-progress enrollments
            const findOneArgs = mockDb.StudentCourse.findOne.firstCall.args[0];
            expect(findOneArgs.where.status).to.have.property(Op.in);
            expect(findOneArgs.where.status[Op.in]).to.deep.equal(['a', 'i']);
        });
        
        it('should return 500 when no instructors available', async () => {
            const mockCourse = { id: 101, name: 'Math 101' };
            
            mockDb.Course.findByPk.resolves(mockCourse);
            mockDb.StudentCourse.findOne.resolves(null);
            mockDb.User.findOne.resolves(null); // No instructors
            
            const response = await request(app)
                .post('/student_course')
                .send({ courseId: 101 })
                .expect(500);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('No instructors available');
        });
    });
    
    describe('PUT /student_course/:id', () => {
        it('should update student course', async () => {
            const mockStudentCourse = {
                id: 1,
                userId: 1,
                status: 'i',
                update: sinon.stub().resolves()
            };
            
            mockDb.StudentCourse.findOne.resolves(mockStudentCourse);
            
            const response = await request(app)
                .put('/student_course/1')
                .send({ status: 'a' })
                .expect(200);
            
            expect(mockStudentCourse.update.calledWith({ status: 'a' })).to.be.true;
        });
        
        it('should return 404 when student course not found', async () => {
            mockDb.StudentCourse.findOne.resolves(null);
            
            const response = await request(app)
                .put('/student_course/999')
                .send({ status: 'a' })
                .expect(404);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Student course not found or access denied');
        });
        
        it('should return 400 when trying to change completed course status', async () => {
            const mockStudentCourse = {
                id: 1,
                userId: 1,
                status: 'c',
                update: sinon.stub()
            };
            
            mockDb.StudentCourse.findOne.resolves(mockStudentCourse);
            
            const response = await request(app)
                .put('/student_course/1')
                .send({ status: 'a' })
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Cannot change status of completed course');
        });
        
        it('should return 400 for invalid status', async () => {
            const mockStudentCourse = {
                id: 1,
                userId: 1,
                status: 'i',
                update: sinon.stub()
            };
            
            mockDb.StudentCourse.findOne.resolves(mockStudentCourse);
            
            const response = await request(app)
                .put('/student_course/1')
                .send({ status: 'invalid' })
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.include('Invalid status');
        });
        
        it('should return 400 for invalid date range', async () => {
            const mockStudentCourse = {
                id: 1,
                userId: 1,
                status: 'i',
                update: sinon.stub()
            };
            
            mockDb.StudentCourse.findOne.resolves(mockStudentCourse);
            
            const response = await request(app)
                .put('/student_course/1')
                .send({ 
                    startDate: '2024-12-31', 
                    endDate: '2024-01-01' 
                })
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('End date must be after start date');
        });
    });
    
    describe('DELETE /student_course/:id', () => {
        it('should delete student course', async () => {
            const mockStudentCourse = {
                id: 1,
                userId: 1,
                status: 'i'
            };
            
            // Setup transaction mock to work with withTransaction
            const mockTransaction = {
                commit: sinon.stub().resolves(),
                rollback: sinon.stub().resolves()
            };
            
            mockDb.sequelize.transaction.callsFake(async (callback) => {
                if (callback) {
                    return await callback(mockTransaction);
                }
                return mockTransaction;
            });
            
            mockDb.StudentCourse.findOne.resolves(mockStudentCourse);
            mockDb.StudentAssessment.destroy.resolves(2);
            mockDb.StudentCourse.destroy.resolves(1);
            
            const response = await request(app)
                .delete('/student_course/1')
                .expect(200);
            
            expect(response.body.success).to.equal(true);
            expect(response.body.message).to.equal('Student course deleted successfully');
            expect(response.body.deletedCount).to.equal(1);
            
            // Verify StudentAssessment.destroy was called with correct parameters
            expect(mockDb.StudentAssessment.destroy.calledOnce).to.be.true;
            const assessmentDestroyArgs = mockDb.StudentAssessment.destroy.firstCall.args[0];
            expect(assessmentDestroyArgs.where.student_courseId).to.equal(1);
            expect(assessmentDestroyArgs.transaction).to.equal(mockTransaction);
            
            // Verify StudentCourse.destroy was called with correct parameters
            expect(mockDb.StudentCourse.destroy.calledOnce).to.be.true;
            const courseDestroyArgs = mockDb.StudentCourse.destroy.firstCall.args[0];
            expect(courseDestroyArgs.where.id).to.equal(1);
            expect(courseDestroyArgs.transaction).to.equal(mockTransaction);
        });
        
        it('should return 404 when student course not found', async () => {
            mockDb.StudentCourse.findOne.resolves(null);
            
            const response = await request(app)
                .delete('/student_course/999')
                .expect(404);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Student course not found or access denied');
        });
        
        it('should return 400 when trying to delete completed course', async () => {
            const mockStudentCourse = {
                id: 1,
                userId: 1,
                status: 'c'
            };
            
            mockDb.StudentCourse.findOne.resolves(mockStudentCourse);
            
            const response = await request(app)
                .delete('/student_course/1')
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Cannot delete completed courses');
        });
        
        it('should return 400 for invalid ID', async () => {
            const response = await request(app)
                .delete('/student_course/invalid')
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.include('Invalid student course ID');
        });
    });
});