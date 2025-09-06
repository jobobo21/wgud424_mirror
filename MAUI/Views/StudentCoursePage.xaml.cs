using System.Diagnostics;
using System.Net.Http.Json;
using wgud424_maui.Models;
using wgud424_maui.Services;

namespace wgud424_maui.Views;

public partial class StudentCoursePage : ContentPage
{
    StudentCourse studentCourse = new StudentCourse();
    public async void GetData(int id)
    {
        HttpResponseMessage response = await DatabaseHandler.Get($"/student_course/{id}");
        if (response != null)
        {
            if (response.IsSuccessStatusCode)
            {
                // Request was successful (e.g., 200 OK, 201 Created)
                // Optionally, read the response content if the API returns data
                studentCourse = await response.Content.ReadFromJsonAsync<StudentCourse>();
                string jsonString = await response.Content.ReadAsStringAsync();
                Debug.WriteLine(jsonString);

                if (studentCourse != null)
                {
                    ContentPage.Title = studentCourse.Course.code;
                    CU_lbl.Text = $"CUs: {studentCourse.Course.competency_units}";
                    Description_lbl.Text = studentCourse.Course.description;
                    Instructor_lbl.Text = $"{studentCourse.Instructor.first_name} {studentCourse.Instructor.last_name}";
                    Instructor_Email_lbl.Text = studentCourse.Instructor.email;
                    StartDate_pkr.Date = studentCourse.startDate;
                    EndDate_pkr.Date = studentCourse.endDate;
                    AssessmentList.ItemsSource = studentCourse.studentAssessments;
                }
            }
            else
            {
                // Request failed, handle the error
                Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }
        }
    }
    public StudentCoursePage(int studentCourseId)
	{
		InitializeComponent();

        GetData(studentCourseId );
	}

    private void AssessmentList_ItemSelected(object sender, SelectedItemChangedEventArgs e)
    {
        StudentAssessment ca = AssessmentList.SelectedItem as StudentAssessment;
        if (ca != null) {
            AssessmentPage ap = new AssessmentPage(ca.student_assessmentId);
            Navigation.PushModalAsync(ap);
        }
    }
    //protected override void OnDisappearing()
    //{
    //    base.OnDisappearing();
    //    Navigation.PopToRootAsync();
    //}
    protected override void OnAppearing()
    {
        base.OnAppearing();
        AssessmentList.SelectedItem = null;
    }
}