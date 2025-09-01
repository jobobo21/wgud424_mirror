using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using wgud424_maui.Services;
using System.Net.Http.Json;



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

        public async Task Populate(int id)
        {
            HttpResponseMessage hrm = await DatabaseHandler.Get("/terms/"+id);
            if (hrm != null) {
                var result = await hrm.Content.ReadFromJsonAsync<Term>();
                this.id = result.id;
                this.term_no = result.term_no;
                this.startDate = result.startDate;
                this.endDate = result.endDate;
                this.student_id = result.student_id;
                this.courses = result.courses;
            }
        }
    }
}
