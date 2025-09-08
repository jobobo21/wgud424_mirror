using System.Diagnostics;
using System.Net.Http.Json;
using CommunityToolkit.Maui.Core;
using Microsoft.Maui;
using wgud424_maui.Models;
using wgud424_maui.Services;
using static System.Net.Mime.MediaTypeNames;
namespace wgud424_maui.Views;
using CommunityToolkit.Maui.Alerts;

public partial class StudentCoursePage : ContentPage
{
    StudentCourse studentCourse = new StudentCourse();
    TermView parent { get; set; }

    public async void GetData(int id)
    {
        HttpResponseMessage response = await DatabaseHandler.Get($"/student_course/{id}");
        if (response != null)
        {
            if (response.IsSuccessStatusCode)
            {
                studentCourse = await response.Content.ReadFromJsonAsync<StudentCourse>();
                string jsonString = await response.Content.ReadAsStringAsync();
                Debug.WriteLine(jsonString);

                if (studentCourse != null)
                {
                    ContentPage.Title = studentCourse.Course.code;
                    CU_lbl.Text = $"CUs: {studentCourse.Course.competency_units}";
                    Description_lbl.Text = studentCourse.Course.description;

                    if (studentCourse.Instructor != null)
                    {
                        Instructor_lbl.Text = $"{studentCourse.Instructor.first_name} {studentCourse.Instructor.last_name}";
                        Instructor_Email_lbl.Text = studentCourse.Instructor.email;
                    }

                    StartDate_pkr.Date = studentCourse.startDate;
                    EndDate_pkr.Date = studentCourse.endDate;

                    // Updated status display logic
                    UpdateStatusDisplay(studentCourse.status);

                    AssessmentList.ItemsSource = studentCourse.studentAssessments;
                }
            }
            else
            {
                Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }
        }
    }

    private void UpdateStatusDisplay(string status)
    {
        switch (status.ToLower())
        {
            case "c": // Complete
                StatusLabel.TextColor = Color.FromArgb("#2E7D32");
                StatusLabel.Text = "✅ Complete";
                ActivateButtonFrame.IsVisible = false;
                break;

            case "a": // Active
                StatusLabel.TextColor = Color.FromArgb("#F57C00");
                StatusLabel.Text = "🟢 Active";
                ActivateButtonFrame.IsVisible = false;
                break;

            case "i": // Inactive
            default:
                StatusLabel.TextColor = Color.FromArgb("#757575");
                StatusLabel.Text = "⚪ Inactive";
                ActivateButtonFrame.IsVisible = true;
                Activate_btn.Text = "Activate";
                break;
        }
    }

    public StudentCoursePage(int studentCourseId, TermView tv)
    {
        InitializeComponent();
        GetData(studentCourseId);
        parent = tv;
    }

    private void AssessmentList_ItemSelected(object sender, SelectedItemChangedEventArgs e)
    {
        StudentAssessment ca = AssessmentList.SelectedItem as StudentAssessment;
        if (ca != null)
        {
            AssessmentPage ap = new AssessmentPage(ca.student_assessmentId);
            Navigation.PushModalAsync(ap);
        }
    }

    protected override void OnAppearing()
    {
        base.OnAppearing();
        AssessmentList.SelectedItem = null;
    }

    private async void DeleteStudentCourse_btn_Clicked(object sender, EventArgs e)
    {
        bool response = await DatabaseHandler.Delete($"/student_course/{studentCourse.id}");
        if (response == true)
        {
            Navigation.PopAsync();
            parent.Refresh();
        }
        else
        {
            Debug.WriteLine("Error Deleting Course from Term");
        }
    }

    // Add click handler for the Activate button
    private async void Activate_btn_Clicked(object sender, EventArgs e)
    {
        try
        {
            StudentCourse tmpSc = studentCourse;
            tmpSc.status = "a";
            JsonContent jc = JsonContent.Create<StudentCourse>(tmpSc);

            var response = await DatabaseHandler.Put($"/student_course/{tmpSc.id}", jc);
            if (response == true)
            {
                // Instead of calling GetData, update the UI directly
                studentCourse.status = "a";

                // Check if UI elements are still valid before updating
                MainThread.BeginInvokeOnMainThread(() =>
                {
                    try
                    {
                        if (this.Handler != null && StatusLabel?.Handler != null)
                        {
                            UpdateStatusDisplay("a");

                            ToastDuration duration = ToastDuration.Short;
                            string text = "Course has been activated";
                            int fontSize = 14;
                            var toast = Toast.Make(text, duration, fontSize);
                            toast.Show();
                        }
                    }
                    catch (ObjectDisposedException ex)
                    {
                        Debug.WriteLine($"UI update failed - page disposed: {ex.Message}");
                    }
                });
            }
            Debug.WriteLine($"\n\n\nResponse: {response}\n\n\n");
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Error activating course: {ex.Message}");

            // Also wrap DisplayAlert in MainThread check
            MainThread.BeginInvokeOnMainThread(async () =>
            {
                try
                {
                    if (this.Handler != null)
                    {
                        await DisplayAlert("Error", "An error occurred while activating the course.", "OK");
                    }
                }
                catch (ObjectDisposedException)
                {
                    Debug.WriteLine("Could not show error alert - page disposed");
                }
            });
        }
    }
}