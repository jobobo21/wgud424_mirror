using System.Net.Http.Json;
using System;
using System.Diagnostics;
using wgud424_maui.Services;
using wgud424_maui.Views;
namespace wgud424_maui
{
    public partial class MainPage : ContentPage
    {
        int count = 0;
        private AppShell parentShell { get; set; }

        public class StudentStatus
        {
            public int complete_cu { get; set; }
            public int active_cu { get; set; }
            public int total_cu { get; set; }
            public float pct_complete { get; set; }
            public int remaining_cu { get; set; }
            public string user_first_name { get; set; } = string.Empty;
            public string user_last_name { get; set; } = string.Empty;
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
                    var result = await response.Content.ReadFromJsonAsync<StudentStatus>();
                    string jsonString = await response.Content.ReadAsStringAsync();
                    if (result != null) {
                        Debug.WriteLine(jsonString);
                        Debug.WriteLine($"API response: {result.complete_cu}, {result.total_cu}");
                        NameLabel.Text = $"Welcome Back {result.user_first_name} {result.user_last_name}";
                        float progress = (float)result.complete_cu / (float)result.total_cu;
                        Debug.WriteLine($"Progress ${progress}");
                        CourseProgress.Progress = progress;
                        ProgressLabel.Text = $"{result.pct_complete}% Complete";
                        CUBreakDown.Text = $"{result.complete_cu} CUs Complete, {result.active_cu} CUs Active";
                        parentShell.PopulateTerms();
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

        private void OnCounterClicked(object sender, EventArgs e)
        {
            count++;

            if (count == 1)
                CounterBtn.Text = $"Clicked {count} time";
            else
                CounterBtn.Text = $"Clicked {count} times";
            GetData();
            SemanticScreenReader.Announce(CounterBtn.Text);
        }
    }

}
