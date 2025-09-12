using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using System.Net.Http.Json;
using System.Diagnostics; // Required for PostAsJsonAsync
namespace wgud424_maui.Services
{

    internal class DatabaseHandler
    {

        private static HttpRequestMessage message;
        private static HttpClient client { get; set; }
       
        async static Task<HttpClient> init(string path)
        {
            string token = await SecureStorage.Default.GetAsync("JWT");
            client = new HttpClient();
            client.DefaultRequestHeaders.Add("Authorization", token);
            return client;

        }
        async public static Task<HttpResponseMessage> Get(string path)
        {
            try
            {
                client = await init(path);

                message = new HttpRequestMessage(HttpMethod.Get, $"https://king-prawn-app-y5xwb.ondigitalocean.app{path}");

                HttpResponseMessage response = await client.SendAsync(message);
                return response;
            }
            catch (Exception ex) {
                throw new Exception(ex.Message);
            }
           

        }
        async public static Task<bool> Put(string path, JsonContent jc)
        {
            Debug.WriteLine($"\n\n\nPUT Path {path}\n\n\n");
            try
            {
                client = await init(path);

                HttpRequestMessage message = new HttpRequestMessage(HttpMethod.Put, "https://king-prawn-app-y5xwb.ondigitalocean.app"+path);
                message.Content = jc;

                HttpResponseMessage response = await client.SendAsync(message);
                // response.StatusCode = System.Net.HttpStatusCode.Unauthorized;
                if (response.IsSuccessStatusCode)
                {
                    Debug.WriteLine($"\n\n\nResponse: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}\n\n\n");

                    return true;
                }
                else
                {
                    Debug.WriteLine($"\n\n\nResponse: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}\n\n\n");

                    
                    Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                    return false;
                }

            }
            catch (Exception e)
            {
                Debug.Write($"\n\n\n\nPUT Path {path}\n\n\n\n");
                throw new Exception(e.Message);
            }
        }
        async public static Task<HttpResponseMessage> Post(string path, JsonContent jc)
        {
            try
            {
                client = await init(path);

                HttpRequestMessage message = new HttpRequestMessage(HttpMethod.Post, "https://king-prawn-app-y5xwb.ondigitalocean.app" + path);
                string jsonContent = await jc.ReadAsStringAsync();
                Debug.WriteLine(jsonContent);
                message.Content = jc;

                HttpResponseMessage response = await client.SendAsync(message);
                Debug.WriteLine($"\n\n\nResponse: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}\n\n\n");
                return response;

            }
            catch (Exception e)
            {
                Debug.Write($"Post Path {path}");
                
                Debug.WriteLine(e.Message);

                throw new Exception(e.Message);
            }
        }
        async public static Task<bool> Delete(string path)
        {
            try
            {
                client = await init(path);

                HttpRequestMessage message = new HttpRequestMessage(HttpMethod.Delete, "https://king-prawn-app-y5xwb.ondigitalocean.app" + path);

                HttpResponseMessage response = await client.SendAsync(message);
                // response.StatusCode = System.Net.HttpStatusCode.Unauthorized;
                if (response.IsSuccessStatusCode)
                {
                    Debug.WriteLine("       \n\n\n\n\n\nDelete Successfull \n\n\n\n\n");
                    return true;
                }
                else
                {
                    Debug.Write($"Delete Path {path}");
                    Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                    return false;
                }

            }
            catch (Exception e)
            {
                Debug.Write($"Delete Path {path}");
                throw new Exception(e.Message);
            }
        }
    }
}
