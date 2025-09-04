using System.Text.Json.Serialization;
using System.Threading.Tasks;
using wgud424_maui.Models;
using wgud424_maui.Services;
namespace wgud424_maui.Views;



public partial class TermView : ContentPage
{
	private Term tm = new Term();
	public void Init()
	{
		CourseListView.ItemsSource = tm.StudentCourses;
	}
	public TermView(Term tmpTerm, AppShell parent)
	{

		InitializeComponent();
		TermPage.Title = "Term " + tmpTerm.term_no;
		tm = tmpTerm;
		Init();
	}

    private void CourseListView_ItemSelected(object sender, SelectedItemChangedEventArgs e)
    {

    }
}