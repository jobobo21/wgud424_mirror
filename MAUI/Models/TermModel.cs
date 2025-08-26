using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace wgud424_maui.Models
{
    internal class TermDb
    {
        public int id { get; set; }
        public int term_no { get; set; }
        public DateTime startDate { get; set; }
        public DateTime endDate { get; set; }
        public int student_id { get; set; }

    }
    internal class Term : TermDb
    {
   
        public List<Course> courses { get; set; } = new List<Course>();
    }
}
