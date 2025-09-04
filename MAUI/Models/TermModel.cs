using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using wgud424_maui.Services;
using System.Net.Http.Json;



namespace wgud424_maui.Models
{
    public class Term
    {
        public int id { get; set; }
        public int term_no { get; set; }
        public DateTime startDate { get; set; }
        public DateTime endDate { get; set; }
        public int student_id { get; set; }
        public Student Student { get; set; } = new Student();
        public List<StudentCourse> StudentCourses { get; set; } = new List<StudentCourse>();
    }



 
}
