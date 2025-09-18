using System.Diagnostics;
using System.Net.Http.Json;
using CommunityToolkit.Maui.Alerts;
using CommunityToolkit.Maui.Core;
using Microsoft.Maui.Platform;
using wgud424_maui.Models;
using wgud424_maui.Services;

namespace wgud424_maui.Views;

public partial class AssessmentPage : ContentPage
{
    private StudentAssessment _assessment = new StudentAssessment();
    private StudentCoursePage _parent { get; set; }
    public async void GetData(int id)
    {
        HttpResponseMessage response = await DatabaseHandler.Get($"/student_assessment/{id}");
        if (response != null)
        {
            if (response.IsSuccessStatusCode)
            {
    
                _assessment = await response.Content.ReadFromJsonAsync<StudentAssessment>();
                string jsonString = await response.Content.ReadAsStringAsync();
                Debug.WriteLine(jsonString);
                Title_lbl.Text = _assessment.Assessment.name;
                
                PassingScore_lbl.Text = $"{_assessment.Assessment.passing_score.ToString()}%";
                Description_lbl.Text = _assessment.Assessment.description;
                if(StartDate_date != null)
                {
                    StartDate_date.MinimumDate = _parent.studentCourse.startDate;
                    StartDate_date.MaximumDate = _parent.studentCourse.endDate;
                }
                if (EndDate_date != null)
                {
                    EndDate_date.MinimumDate = _parent.studentCourse.startDate;
                    EndDate_date.MaximumDate = _parent.studentCourse.endDate;
                }
                                   
                if (_assessment.startDate != null)
                {
                    StartDate_time.Time = _assessment.startDate.Value.TimeOfDay;
                    StartDate_date.Date = _assessment.startDate.Value.Date;
                }
                if (_assessment.endDate != null)
                {
                    EndDate_time.Time = _assessment.endDate.Value.TimeOfDay;
                    EndDate_date.Date = _assessment.endDate.Value.Date;
                }
                if(_parent.studentCourse.status == "c")
                {
                    EndDate_date.IsEnabled = false;
                    EndDate_time.IsEnabled = false;
                    StartDate_date.IsEnabled = false;
                    StartDate_time.IsEnabled = false;
                }
            }
            else
            {
                // Request failed, handle the error
                Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }
        }
    }
    public AssessmentPage(int assessmentId, StudentCoursePage parent)
	{
		InitializeComponent();
        _parent = parent;
        GetData(assessmentId);
	}

     private void Back_btn_Clicked(object sender, EventArgs e)
    {
        Navigation.PopModalAsync();
    }
    private void Toaster(string message)
    {
        ToastDuration duration = ToastDuration.Short;
        string text = message;
        int fontSize = 14;
        var toast = Toast.Make(text, duration, fontSize);
        toast.Show();
    }

    private async void Save_btn_Clicked(object sender, EventArgs e)
    {
        TimeSpan startTime = StartDate_time.Time;
        _assessment.startDate = StartDate_date.Date.Add(startTime);
        TimeSpan endTime = EndDate_time.Time;
        _assessment.endDate = EndDate_date.Date.Add(endTime);
        JsonContent jc = JsonContent.Create<StudentAssessment>(_assessment);
        var response = await DatabaseHandler.Put($"/student_assessment/{_assessment.student_assessmentId}", jc);
        if (response)
        {
            Toaster("Assessment has been updated");
        }
        else
        {
            Toaster("Assessment Update Failure");
        }

    }
}