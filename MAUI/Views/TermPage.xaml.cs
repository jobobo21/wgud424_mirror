using System.Text.Json.Serialization;
using wgud424_maui.Models;
using wgud424_maui.Services;
using System.Diagnostics;
namespace wgud424_maui.Views;

public partial class TermView : ContentPage
{
    private Term tm = new Term();

    public void Init()
    {
        int complete = 0;
        int active = 0;
        try
        {
            if (tm?.StudentCourses != null)
            {
                // Debug output to see what data we have
                Debug.WriteLine($"Found {tm.StudentCourses.Count} student courses");
                CourseListView.ItemsSource = tm.StudentCourses;
                foreach (var course in tm.StudentCourses)
                {
                    Debug.WriteLine($"Student Course ID: {course.id}");
                    Debug.WriteLine($"Course ID: {course.courseId}");
                    Debug.WriteLine($"Status: {course.status}");
                    if(course.status == "a")
                    {
                        active += 1;
                    }
                    else if(course.status == "c")
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
                CompletedCoursesLabel.Text = complete.ToString();
                ActiveCoursesLabel.Text = active.ToString();
                TotalCoursesLabel.Text = tm.StudentCourses.Count.ToString();
                
                
             
            }
            else
            {
                Debug.WriteLine("No StudentCourses found or tm is null");
            }
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Error in Init: {ex.Message}");
        }
    }

    public TermView(Term tmpTerm, AppShell parent)
    {
        InitializeComponent();

        if (tmpTerm != null)
        {
            TermPage.Title = "Term " + tmpTerm.term_no;
            tm = tmpTerm;
            Init();
        }
        else
        {
            Debug.WriteLine("tmpTerm is null in constructor");
        }
    }

    private void CourseListView_ItemSelected(object sender, SelectedItemChangedEventArgs e)
    {
        try
        {
            // Deselect the item
            CourseListView.SelectedItem = null;

            if (e.SelectedItemIndex >= 0 && e.SelectedItemIndex < tm.StudentCourses.Count)
            {
                StudentCourse sc = tm.StudentCourses[e.SelectedItemIndex];
                Debug.WriteLine($"Selected course with ID: {sc.id}");

                StudentCoursePage scp = new StudentCoursePage(sc.id);
                Navigation.PushAsync(scp);
            }
            else
            {
                Debug.WriteLine($"Invalid selection index: {e.SelectedItemIndex}");
            }
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Error in CourseListView_ItemSelected: {ex.Message}");
        }
    }
}