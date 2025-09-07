using System.Net.Http.Json;
using System;
using System.Diagnostics;
using wgud424_maui.Services;
using wgud424_maui.Views;
using wgud424_maui.Models;
namespace wgud424_maui
{
    public class StudentStatus
    {
        public int complete_cu { get; set; }
        public int active_cu { get; set; }
        public int total_cu { get; set; }
        public float pct_complete { get; set; }
        public int remaining_cu { get; set; }
        public string user_first_name { get; set; } = string.Empty;
        public string user_last_name { get; set; } = string.Empty;
        public Mentor mentor { get; set; }
    }
    public partial class MainPage : ContentPage
    {
        int count = 0;
        public StudentStatus ss { get; set; }
        private AppShell parentShell { get; set; }

       
        public void RenderData()
        {
            Debug.WriteLine($"API response: {ss.complete_cu}, {ss.total_cu}");
            NameLabel.Text = $"Welcome Back {ss.user_first_name} {ss.user_last_name}";
            float progress = (float) ss.complete_cu / (float)ss.total_cu;
            Debug.WriteLine($"Progress ${progress}");
            CourseProgress.Progress = progress;
            ProgressLabel.Text = $"{ss.pct_complete}% Complete";
            CUBreakDown.Text = $"{ss.complete_cu} CUs Complete, {ss.active_cu} CUs Active";
            MentorName_lbl.Text = $"{ss.mentor.first_name} {ss.mentor.last_name}";
            MentorEmail_lbl.Text = ss.mentor.email;

        }
        public async void GetData()
        {
            HttpResponseMessage response = await DatabaseHandler.Get("/user/student_status");
            if (response != null)
            {
                if (response.IsSuccessStatusCode)
                {
                    // Request was successful (e.g., 200 OK, 201 Created)
                    // Optionally, read the response content if the API returns data
                    ss = await response.Content.ReadFromJsonAsync<StudentStatus>();
                    string jsonString = await response.Content.ReadAsStringAsync();

                    Debug.WriteLine(jsonString);

                    if (ss != null) {
                        RenderData();
                        parentShell.PopulateTerms(ss);
                    }
                }
                else
                {
                    // Request failed, handle the error
                    Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                }
            }
        }

        public MainPage(AppShell p)
        {
            InitializeComponent();
            Navigation.PushModalAsync(new LoginModal(this));
            parentShell = p;
        }

        private void DegreePlan_btn_Clicked(object sender, EventArgs e)
        {
            DegreePlanReport drp = new DegreePlanReport();
            Navigation.PushModalAsync(drp);
        }

        private void StudentSearch_btn_Clicked(object sender, EventArgs e)
        {
            StudentSearch studentSearch = new StudentSearch();
            Navigation.PushModalAsync(studentSearch);
        }
    }

}
