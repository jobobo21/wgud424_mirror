using System.Diagnostics;
using System.Net.Http.Json;
using CommunityToolkit.Maui.Core.Views;
using wgud424_maui.Models;
using wgud424_maui.Services;

namespace wgud424_maui.Views;

public class DisplayCourse: Course
{
    public int program_id;
}

public partial class AddCoursePage : ContentPage
{
    public TermView parent;
    List<DisplayCourse> ca {  get; set; } = new List<DisplayCourse>();
    public AddCoursePage(TermView tv)
    {
        parent = tv;
        InitializeComponent();
        
        GetData();
    }
    public async void GetData()
    {
        HttpResponseMessage response = await DatabaseHandler.Get($"/student_course/upcomming");
        if (response != null)
        {
            if (response.IsSuccessStatusCode)
            {

                ca = await response.Content.ReadFromJsonAsync<List<DisplayCourse>>();
                string jsonString = await response.Content.ReadAsStringAsync();
                Debug.WriteLine(jsonString);
                Title.Text = $"Add Course to Term {parent.tm.term_no}";
                if (ca.Count > 0)
                {
                       CourseList.ItemsSource = ca;
                }

            }
            else
            {
                // Request failed, handle the error
                Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }
        }
    }
 

    private void CloseButton_Clicked(object sender, EventArgs e)
    {
        Navigation.PopModalAsync();
    }

    private async void OnCourseTapped(object sender, EventArgs e)
    {
        if (sender is StackLayout stackLayout && stackLayout.BindingContext is DisplayCourse course)
        {
            // Handle the tap
            //Debug.WriteLine($"\n\n\n\nTapped: {course.name}\n\n\n\n\n");
            AddCourseForm addCourseForm = new AddCourseForm();
            addCourseForm.dc = course;
            addCourseForm.tv = parent;
            addCourseForm.Init();
            Navigation.PushModalAsync(addCourseForm);
        }
    }
}