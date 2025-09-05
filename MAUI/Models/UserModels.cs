using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace wgud424_maui.Models
{
    public class User
    {
        public int id {  get; set; }
        public string email { get; set; } = string.Empty;
        public string first_name { get; set; } = string.Empty;
        public string last_name { get; set;} = string.Empty;
        public string password { get; set; } = string.Empty;
        public int mentor_id { get; set; }
        public string user_type { get; set; } = string.Empty;
        public DateTime grad_date { get; set; }

        public int program_id { get; set; }


    }

    public class Student : User
    {
        public User mentor { get; set; }


    }

    public class Mentor : User
    {
        public List<User> students { get; set; } = new List<User>();

    }
    public class StudentCourse
    {
        public int id { get; set; }
        public int userId { get; set; }
        public int instructorId { get; set; }
        public int courseId { get; set; }
        public DateTime startDate { get; set; }
        public DateTime endDate { get; set; }
        public string status { get; set; }
        public int term_id { get; set; }
        public Course Course { get; set; }
        public Instructor Instructor { get; set; }
    }



    public class Instructor
    {
        public int id { get; set; }
        public string first_name { get; set; } = string.Empty;
        public string last_name { get; set; } = string.Empty;
        public string email { get; set; } = string.Empty;
        public string user_type { get; set; } = string.Empty;
    }
}
