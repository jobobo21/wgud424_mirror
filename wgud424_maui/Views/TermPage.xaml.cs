using System.Text.Json.Serialization;
using wgud424_maui.Models;
using wgud424_maui.Services;
using System.Diagnostics;
using System.Net.Http.Json;
using CommunityToolkit.Maui.Alerts;
using CommunityToolkit.Maui.Core;

namespace wgud424_maui.Views;

public partial class TermView : ContentPage
{
    public Term tm = new Term();
    private bool _isDisposed = false;
    AddCoursePage acp { get; set; }
    private AppShell _parent { get; set; }
    public async void Refresh()
    {
        HttpResponseMessage response = await DatabaseHandler.Get($"/terms/{tm.id}");
        CourseListView.ItemsSource = new List<StudentCourse>();
        if (response != null)
        {
            if (response.IsSuccessStatusCode)
            {

                tm = await response.Content.ReadFromJsonAsync<Term>();
                CourseListView.ItemsSource = tm.StudentCourses;
                StartDatePicker.Text = tm.startDate.ToString("d");
                EndDatePicker.Text = tm.endDate.ToString("d");
                string jsonString = await response.Content.ReadAsStringAsync();
                Debug.WriteLine(jsonString);
                acp = new AddCoursePage(this);
                if(tm != null)
                {
                    Init();
                }

            }
            else
            {
                // Request failed, handle the error
                Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }
        }
    }
    public void Init()
    {
        int complete = 0;
        int active = 0;
        Debug.WriteLine($"\n\n\n\n Init Function Started {tm.StudentCourses.Count}\n\n\n\n\n");
        try
        {
            if (tm?.StudentCourses != null)
            {
                // Debug output to see what data we have
                Debug.WriteLine($"Found {tm.StudentCourses.Count} student courses");

                if (CourseListView != null && !_isDisposed)
                {
                    CourseListView.ItemsSource = tm.StudentCourses;
                }

                foreach (var course in tm.StudentCourses)
                {
                    Debug.WriteLine($"Student Course ID: {course.id}");
                    Debug.WriteLine($"Course ID: {course.courseId}");
                    Debug.WriteLine($"Status: {course.status}");
                    if (course.status == "a")
                    {
                        active += 1;
                    }
                    else if (course.status == "c")
                    {
                        complete += 1;
                    }
                    if (course.Course != null)
                    {
                        Debug.WriteLine($"Course Code: {course.Course.code}");
                        Debug.WriteLine($"Course Name: {course.Course.name}");
                        Debug.WriteLine($"Course Description: {course.Course.description}");
                    }
                    else
                    {
                        Debug.WriteLine("Course navigation property is null");
                    }
                    Debug.WriteLine("---");
                }

                // Update statistics with null checks
                //if (CompletedCoursesLabel != null && !_isDisposed)
                    CompletedCoursesLabel.Text = complete.ToString();
                //if (ActiveCoursesLabel != null && !_isDisposed)
                    ActiveCoursesLabel.Text = active.ToString();
                //if (TotalCoursesLabel != null && !_isDisposed)
                    TotalCoursesLabel.Text = tm.StudentCourses.Count.ToString();
                StartDatePicker.Text = tm.startDate.ToString("d");
                EndDatePicker.Text = tm.endDate.ToString("d");
                DeleteTerm_btn.IsVisible = false;
                if (tm.StudentCourses.Count == 0)
                {
                    DeleteTerm_btn.IsVisible = true;
                }
                
            }
            else
            {
                Debug.WriteLine("No StudentCourses found or tm is null");
            }
        }
        catch (ObjectDisposedException)
        {
            _isDisposed = true;
            Debug.WriteLine("Page was disposed during Init");
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Error in Init: {ex.Message}");
        }
    }

    public TermView(Term tmpTerm, AppShell parent)
    {
        try
        {
            InitializeComponent();
            acp = new AddCoursePage(this);
            _parent = parent;
            if (tmpTerm != null)
            {
                if (TermPage != null && !_isDisposed)
                    TermPage.Title = "Term " + tmpTerm.term_no;
                tm = tmpTerm;
                acp.parent = this;
                Init();
            }
            else
            {
                Debug.WriteLine("tmpTerm is null in constructor");
            }
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Error in constructor: {ex.Message}");
        }
    }

    private async void CourseListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        Debug.WriteLine("Selection Changed");

        try
        {
        if (e.CurrentSelection != null)
            {
                StudentCourse sc = (StudentCourse)CourseListView.SelectedItem;
                Debug.WriteLine($"Selected course with ID: {sc.id}");

                StudentCoursePage scp = new StudentCoursePage(sc.id, this);
                await Navigation.PushAsync(scp);

            }
           
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Error in CourseListView_ItemSelected: {ex.Message}");
        }
    }

    protected override void OnDisappearing()
    {
        try
        {
            _isDisposed = true;
            base.OnDisappearing();
        }
        catch (ObjectDisposedException)
        {
            // Already disposed, ignore
        }
    }
    protected override void OnAppearing()
    {
        base.OnAppearing();
        CourseListView.SelectedItem = null;
        Init();
        Navigation.PopToRootAsync();

    }
    protected override bool OnBackButtonPressed()
    {
        _isDisposed = true;
        return base.OnBackButtonPressed();
    }

    private void AddCourse_btn_Clicked(object sender, EventArgs e)
    {
        
        Navigation.PushModalAsync(acp);

    }
    private void Toaster(string message)
    {
        var toast = Toast.Make(message, ToastDuration.Short, 14);
        toast.Show();
    }
    private async void DeleteTerm_btn_Clicked(object sender, EventArgs e)
    {
        bool response = await DatabaseHandler.Delete($"/terms/{tm.id}");
        if (response)
        {
            Toaster("Term Removed Successfully!");
            _parent.PopulateTerms();
        }
        else
        {
            Toaster("Term Removal Failure");
        }
    }
}