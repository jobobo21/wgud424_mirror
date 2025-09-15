using System.Diagnostics;
using System.Net.Http.Json;
using wgud424_maui.Services;
using wgud424_maui.Models;

namespace wgud424_maui.Views;

public partial class DegreePlanReport : ContentPage
{
    List<StudentCourse> studentCourseList = new List<StudentCourse>();

    public DegreePlanReport()
    {
        InitializeComponent();
        try
        {
            GetData();
        }
        catch (Exception ex)
        {
            Debug.Write("\n\n\n\n");
            Debug.WriteLine(ex);
            Debug.Write("\n\n\n\n");

        }

    }
    public async void GetData()
    {
        HttpResponseMessage response = await DatabaseHandler.Get("/student_course?include_instructor=true&include_course=true");
        Debug.WriteLine("\n\n\nMade it this far\n\n\n");
        if (response != null)
        {
            if (response.IsSuccessStatusCode)
            {
                studentCourseList = await response.Content.ReadFromJsonAsync<List<StudentCourse>>();
                string jsonString = await response.Content.ReadAsStringAsync();
                Debug.WriteLine(jsonString);

                int i = 1;
                foreach (var sc in studentCourseList)
                {
                    RowDefinition rd = new RowDefinition { Height = new GridLength(50) };
                    ReportGrid.RowDefinitions.Add(rd);

                    // Create styled frames for each cell (now with 5 columns)
                    var codeFrame = CreateDataCellFrame(sc.Course.code, i, 0, i % 2 == 0);
                    var instFrame = CreateDataCellFrame($"{sc.Instructor.first_name} {sc.Instructor.last_name}".Trim(), i, 1, i % 2 == 0);
                    if(sc.createdAt != null)
                    {

                        var startFrame = CreateDataCellFrame(sc.createdAt, i, 2, i % 2 == 0);
                        ReportGrid.Children.Add(startFrame);

                    }
                    if (sc.endDate != null)
                    {
                        var endFrame = CreateDataCellFrame(sc.endDate.ToString("MM/dd/yyyy") ?? "N/A", i, 3, i % 2 == 0);
                        ReportGrid.Children.Add(endFrame);


                    }
                    var statusFrame = CreateDataCellFrame(GetCourseStatus(sc), i, 4, i % 2 == 0);

                    ReportGrid.Children.Add(codeFrame);
                    ReportGrid.Children.Add(instFrame);
                    ReportGrid.Children.Add(statusFrame);

                    i++;
                }
            }
            else
            {
                Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }
        }
    }

    private string GetCourseStatus(StudentCourse sc)
    {
        // Add your logic to determine course status
        if (sc.status == "c")
            return "✅ Complete";
        else if (sc.status == "a")
            return "🔄 Active";
        else
            return "⏳ Pending";
    }

    private Frame CreateDataCellFrame(string text, int row, int column, bool isEvenRow)
    {
        var backgroundColor = isEvenRow ? Color.FromArgb("#F8F9FA") : Colors.White;

        var frame = new Frame
        {
            BackgroundColor = backgroundColor,
            CornerRadius = 5,
            Padding = new Thickness(10, 8),
            HasShadow = false,
            Margin = new Thickness(2),
            Content = new Label
            {
                Text = text,
                FontSize = 14,
                FontAttributes = column == 0 ? FontAttributes.Bold : FontAttributes.None,
                TextColor = Color.FromArgb("#495057"),
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center,
                LineBreakMode = LineBreakMode.TailTruncation,
                MaxLines = 1
            }
        };

        Grid.SetRow(frame, row);
        Grid.SetColumn(frame, column);

        return frame;
    }

    private void Back_btn_Clicked(object sender, EventArgs e)
    {
        Navigation.PopModalAsync();
    }
}