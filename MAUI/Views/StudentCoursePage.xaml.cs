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
        HttpResponseMessage response = await DatabaseHandler.Get($"/user/student_course/{id}");
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
}