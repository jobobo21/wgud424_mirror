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
        public AssessmentType assessment_type { get; set; }
        public string? description { get; set; }
        public int? competency_category_id { get; set; } = 1;
        public bool is_active { get; set; } = true;
        public DateTime created_at { get; set; } = DateTime.UtcNow;
        public DateTime updated_at { get; set; } = DateTime.UtcNow;
    }

    public enum AssessmentType
    {
        Objective,
        Performance,
        Mixed
    }

    public class ProgramDB
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
    }
    public class Program : ProgramDB
    {
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
