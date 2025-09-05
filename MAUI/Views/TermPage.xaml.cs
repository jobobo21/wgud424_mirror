using System.Text.Json.Serialization;
using wgud424_maui.Models;
using wgud424_maui.Services;
using System.Diagnostics;

namespace wgud424_maui.Views;

public partial class TermView : ContentPage
{
    private Term tm = new Term();
    private bool _isDisposed = false;

    public void Init()
    {
        int complete = 0;
        int active = 0;
        try
        {
            if (_isDisposed) return;

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
                if (CompletedCoursesLabel != null && !_isDisposed)
                    CompletedCoursesLabel.Text = complete.ToString();
                if (ActiveCoursesLabel != null && !_isDisposed)
                    ActiveCoursesLabel.Text = active.ToString();
                if (TotalCoursesLabel != null && !_isDisposed)
                    TotalCoursesLabel.Text = tm.StudentCourses.Count.ToString();
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

            if (tmpTerm != null)
            {
                if (TermPage != null && !_isDisposed)
                    TermPage.Title = "Term " + tmpTerm.term_no;
                tm = tmpTerm;
                Init();
            }
            else
            {
                Debug.WriteLine("tmpTerm is null in constructor");
            }
        }
        catch (ObjectDisposedException)
        {
            _isDisposed = true;
            Debug.WriteLine("Page was disposed during construction");
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

                StudentCoursePage scp = new StudentCoursePage(sc.id);
                await Navigation.PushModalAsync(scp);
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

    protected override bool OnBackButtonPressed()
    {
        _isDisposed = true;
        return base.OnBackButtonPressed();
    }
}