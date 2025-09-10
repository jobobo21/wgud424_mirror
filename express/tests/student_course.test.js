// tests/student_course-esmock.test.js
import { expect } from 'chai';
import request from 'supertest';
import express from 'express';
import sinon from 'sinon';
import esmock from 'esmock';

describe('Student Courses Routes with ESMock', () => {
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
        
        // Mock transaction
        const mockTransaction = {
            commit: sinon.stub().resolves(),
            rollback: sinon.stub().resolves()
        };
        mockDb.sequelize.transaction.resolves(mockTransaction);
        
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
            
            expect(response.body.success).to.equal(true);
            expect(response.body.count).to.equal(2);
            expect(response.body.data).to.deep.equal(mockCourses);
        });
        
        it('should filter by status', async () => {
            mockDb.StudentCourse.findAll.resolves([]);
            
            await request(app)
                .get('/student_course?status=a')
                .expect(200);
            
            const callArgs = mockDb.StudentCourse.findAll.firstCall.args[0];
            expect(callArgs.where.status).to.equal('a');
        });
        
        it('should return 400 for invalid status', async () => {
            const response = await request(app)
                .get('/student_course?status=invalid')
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.include('Invalid status');
        });
    });
    
    describe('GET /student_course/upcomming', () => {
        it('should return upcoming courses', async () => {
            const mockUser = {
                id: 1,
                program_id: 1,
                toJSON: () => ({ program_id: 1 })
            };
            
            mockDb.User.findByPk.resolves(mockUser);
            mockDb.StudentCourse.findAll.resolves([]);
            mockDb.ProgramCourse.findAll.resolves([
                {
                    course: { id: 102, name: 'Math 102' },
                    toJSON: () => ({
                        program_id: 1,
                        course: { id: 102, name: 'Math 102' }
                    })
                }
            ]);
            
            const response = await request(app)
                .get('/student_course/upcomming')
                .expect(200);
            
            expect(response.body.success).to.equal(true);
            expect(response.body.count).to.equal(1);
        });
    });
    
    describe('POST /student_course', () => {
        it('should create new enrollment', async () => {
            mockDb.Course.findByPk.resolves({ id: 101, name: 'Math 101' });
            mockDb.StudentCourse.findOne.resolves(null);
            mockDb.User.findOne.resolves({ id: 2, user_type: 'i' });
            mockDb.StudentCourse.create.resolves({
                id: 1,
                userId: 1,
                courseId: 101,
                instructorId: 2,
                status: 'i'
            });
            mockDb.Assessment.findAll.resolves([]);
            mockDb.StudentCourse.findByPk.resolves({
                id: 1,
                userId: 1,
                courseId: 101,
                Course: { id: 101, name: 'Math 101' }
            });
            
            const response = await request(app)
                .post('/student_course')
                .send({ courseId: 101 })
                .expect(201);
            
            expect(response.body.success).to.equal(true);
            expect(response.body.message).to.equal('Student course enrollment created successfully');
        });
        
        it('should return 400 when courseId missing', async () => {
            const response = await request(app)
                .post('/student_course')
                .send({})
                .expect(400);
            
            expect(response.body.success).to.equal(false);
            expect(response.body.message).to.equal('Course ID is required');
        });
    });
});