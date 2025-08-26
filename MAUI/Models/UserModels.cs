using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace wgud424_maui.Models
{
    internal class UserDB
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

    internal class StudentModel : UserDB
    {
        public UserDB mentor { get; set; }


    }
    internal class MentorModel : UserDB
    {
        public List<UserDB> students { get; set; } = new List<UserDB>();

    }

}
