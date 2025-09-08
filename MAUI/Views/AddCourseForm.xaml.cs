using System.Diagnostics;
using System.Net.Http.Json;
using CommunityToolkit.Maui.Alerts;
using CommunityToolkit.Maui.Core;
using wgud424_maui.Models;
using wgud424_maui.Services;
using static System.Net.Mime.MediaTypeNames;

namespace wgud424_maui.Views;

public partial class AddCourseForm : ContentPage
{
	public DisplayCourse dc = new DisplayCourse();
	public TermView? tv { get; set; }
	public void Init()
	{
		CourseCode_lbl.Text = dc.code;
		CourseName_lbl.Text = dc.name;
		CourseDescription_lbl.Text = dc.description;
		if(tv != null)
		{
			StartDate_pkr.MaximumDate = tv.tm.endDate;
			StartDate_pkr.MinimumDate = tv.tm.startDate;
            EndDate_pkr.MaximumDate = tv.tm.endDate;
            EndDate_pkr.MinimumDate = tv.tm.startDate;
        }

	}
	public AddCourseForm()
	{
		InitializeComponent();
	}
	
    private void CancelButton_Clicked(object sender, EventArgs e)
    {
		Navigation.PopModalAsync();
    }

    private async void ConfirmButton_Clicked(object sender, EventArgs e)
    {
		if(StartDate_pkr.Date <= EndDate_pkr.Date)
		{
            StudentCourse sc = new StudentCourse();
            sc.startDate = StartDate_pkr.Date;
            sc.endDate = EndDate_pkr.Date;
            sc.courseId = dc.id;
            sc.term_id = tv.tm.id;
            JsonContent json = JsonContent.Create<StudentCourse>(sc);
            string path = "/student_course";
            HttpResponseMessage hrm = await DatabaseHandler.Post(path, json);

            if (hrm != null && hrm.IsSuccessStatusCode)
            {
                Debug.WriteLine("\n\n\n\n Creation Success \n\n\n\n\n");
                Navigation.PopModalAsync();
                ToastDuration duration = ToastDuration.Short;
                tv.Refresh();
                var toast = Toast.Make("Course Added Successfully!", duration, 14);
                toast.Show();

            }
            else
            {
                Debug.WriteLine("\n\n\n\n Creation Failure \n\n\n\n\n");

            }
        }
        else
        {
            await DisplayAlert("Date Mismatch", "Start Date cannot be later than End Date", "OK");
        }

    }
}