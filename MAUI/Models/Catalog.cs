using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace wgud424_maui.Models
{
    public class Course
    {
        public int id { get; set; }
        public string name { get; set; } = string.Empty;
        public string code { get; set; } = string.Empty;
        public int competency_units { get; set; }
        public string assessment_type { get; set; } = string.Empty;
        public string description { get; set; } = string.Empty;
        public int competency_category_id { get; set; } = 1;
        public bool is_active { get; set; } = true;
        public DateTime created_at { get; set; } = DateTime.UtcNow;
        public DateTime updated_at { get; set; } = DateTime.UtcNow;
        public List<Assessment> assessments { get; set; } = new List<Assessment>();
    }
    public class Assessment
    {
        public int id { get; set; }
        public int course_id { get; set; }
        public string name { get; set; } = string.Empty;
        public string type { get; set; } = string.Empty;
        public string description { get; set; } = string.Empty;
        public decimal? passing_score { get; set; }
        public int max_attempts { get; set; } = 3;
        public int? time_limit_minutes { get; set; }
        public bool is_proctored { get; set; } = false;
        public bool is_required_to_pass { get; set; } = true;
        public int sequence_order { get; set; } = 1;
        public bool is_active { get; set; } = true;
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
        public StudentAssessment studentAssessment { get; set; } = new StudentAssessment();

        // Navigation property
        public Course? Course { get; set; }
        public string TypeDisplayName => type switch
        {
            "O" => "Objective",
            "P" => "Performance",
            _ => "Unknown"
        }; 
    }

    public enum AssessmentType
    {
        Objective,
        Performance,
        Mixed
    }

    public class Program
    {
        public int id { get; set; }
        public string name { get; set; } = string.Empty;
        public string code { get; set; } = string.Empty;
        public DegreeLevel degree_level { get; set; }
        public int college_id { get; set; }
        public int total_competency_units { get; set; }
        public decimal tuition_per_term { get; set; }
        public bool is_active { get; set; } = true;
        public DateTime created_at { get; set; } = DateTime.UtcNow;
        public DateTime updated_at { get; set; } = DateTime.UtcNow;
        public List<Course> courses { get; set; } = new List<Course>();
    }
 
    public enum DegreeLevel
    {
        Certificate,
        Bachelor,
        Master,
        Doctoral
    }
}
