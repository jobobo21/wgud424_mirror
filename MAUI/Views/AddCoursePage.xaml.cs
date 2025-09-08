using System.Diagnostics;
using System.Net.Http.Json;
using CommunityToolkit.Maui.Core.Views;
using wgud424_maui.Models;
using wgud424_maui.Services;
using System.Text.Json;
using System.Collections.ObjectModel;
namespace wgud424_maui.Views;

public class DisplayCourse: Course
{
    public int program_id;
    
}

public partial class AddCoursePage : ContentPage
{
    public TermView parent;
    List<DisplayCourse> ca {  get; set; } = new List<DisplayCourse>();
    private ObservableCollection<DisplayCourse> ca_results = new ObservableCollection<DisplayCourse>();


    List<string> serializedCourses = new List<string>();
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
                if (ca != null)
                {
                    foreach (var course in ca)
                    {
                        ca_results.Add(course);
                    }

                }
                string jsonString = await response.Content.ReadAsStringAsync();
                Debug.WriteLine(jsonString);
                Title.Text = $"Add Course to Term {parent.tm.term_no}";
                if (ca.Count > 0)
                {
                       CourseList.ItemsSource = ca_results;
                    serializedCourses.Clear();
                    foreach (var course in ca)
                    {
                        serializedCourses.Add(JsonSerializer.Serialize(course).ToLower());
                    }
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
            AddCourseForm addCourseForm = new AddCourseForm(course, parent, this);
            Navigation.PushModalAsync(addCourseForm);
        }
    }

    private void SearchEntry_TextChanged(object sender, TextChangedEventArgs e)
    {
        if (SearchEntry.Text.Length > 0) {
            string searchString = SearchEntry.Text.ToLower();
            int i = 0;
            ca_results.Clear();
            
            foreach (var sc in serializedCourses)
            {
                if (sc.IndexOf(searchString) > -1)
                {
                    ca_results.Add(ca[i]);
                }
                i++;
            }
            Debug.WriteLine("\n\n\n\n\nSeralized courses count");
            Debug.WriteLine(serializedCourses.Count);
            Debug.WriteLine("Results");
            Debug.WriteLine(ca_results.Count);
            Debug.WriteLine("\n\n\n\n");

           
        }
        else
        {
            foreach (var course in ca)
            {
                ca_results.Add(course);
            }
        }

   
    }
}