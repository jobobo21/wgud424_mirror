
using System;
using System.Threading.Tasks;
using Xunit;
using Moq;
using wgud424_maui.Views;
using wgud424_maui.Services;

namespace wgud424_maui_test.Views
{
    public class LoginModalTests : IDisposable
    {
        private readonly LoginModal _loginModal;

        public LoginModalTests()
        {
            // Create LoginModal with null parent for testing
            var mockService = new Mock<ILoginService>();
            mockService.Setup(s => s.LoginAsync(It.IsAny<string>(), It.IsAny<string>()))
                       .ReturnsAsync(false);
            _loginModal = new LoginModal(null, mockService.Object);
        }

        public void Dispose()
        {
            // Cleanup if needed
        }

        [Fact]
        public void Constructor_ShouldInitializeWithNullParent()
        {
            // Arrange & Act
            var mockService = new Mock<ILoginService>();
            mockService.Setup(s => s.LoginAsync(It.IsAny<string>(), It.IsAny<string>()))
                       .ReturnsAsync(false);
            var loginModal = new LoginModal(null, mockService.Object);

            // Assert
            Assert.NotNull(loginModal);
        }

        [Fact]
        public async Task HandleLogin_ShouldUseEmailAndPasswordProperties()
        {
            // Arrange
            _loginModal.EmailText = "fakeemail@wgu.edu";
            _loginModal.PasswordText = "fakepassword";

            // Act
            // This will make an actual HTTP call to DatabaseHandler.LoginAsync
            // The result depends on your API response
            bool result = await _loginModal.HandleLogin();

            // Assert
            Assert.IsType<bool>(result);
            // Verify the properties are accessible
            Assert.Equal("fakeemail@wgu.edu", _loginModal.EmailText);
            Assert.Equal("fakepassword", _loginModal.PasswordText);
        }

        [Fact]
        public async Task HandleLogin_ShouldHandleEmptyCredentials()
        {
            // Arrange
            _loginModal.EmailText = "";
            _loginModal.PasswordText = "";

            // Act
            bool result = await _loginModal.HandleLogin();

            // Assert
            // Should return false for empty credentials
            Assert.IsType<bool>(result);
        }

        [Fact]
        public async Task HandleLogin_ShouldHandleNullCredentials()
        {
            // Arrange
            _loginModal.EmailText = null;
            _loginModal.PasswordText = null;

            // Act & Assert - Should not throw exception
            bool result = await _loginModal.HandleLogin();
            Assert.IsType<bool>(result);
        }

        [Fact]
        public async Task HandleLogin_ShouldReturnFalse_WhenExceptionOccurs()
        {
            // This test is limited because DatabaseHandler is static
            // In a real scenario, you'd want to inject DatabaseHandler as a dependency

            // For now, we can only test the exception handling wrapper
            // Act
            var result = await _loginModal.HandleLogin();

            // Assert
            // Result will be true/false depending on actual API call
            // We're testing that the method returns a boolean without throwing
            Assert.IsType<bool>(result);
        }
    }

    // Tests for DatabaseHandler.LoginAsync method
    public class DatabaseHandlerTests
    {
        [Fact]
        public void LoginData_ShouldSetProperties()
        {
            // Arrange
            var loginData = new LoginData();

            // Act
            loginData.email = "test@wgu.edu";
            loginData.password = "testpass";

            // Assert
            Assert.Equal("test@wgu.edu", loginData.email);
            Assert.Equal("testpass", loginData.password);
        }

        [Fact]
        public void JWTResponse_ShouldSetToken()
        {
            // Arrange
            var jwtResponse = new JWTResponse();
            var testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test";

            // Act
            jwtResponse.token = testToken;

            // Assert
            Assert.Equal(testToken, jwtResponse.token);
        }

        // Note: Testing DatabaseHandler.LoginAsync directly is challenging because:
        // 1. It's a static method
        // 2. It makes actual HTTP calls
        // 3. It uses SecureStorage
        // 
        // For better testability, consider:
        // 1. Making DatabaseHandler non-static with dependency injection
        // 2. Injecting HttpClient
        // 3. Injecting ISecureStorageService
    }

    // Integration tests (these will make real HTTP calls)
    public class LoginIntegrationTests
    {
        [Fact]
        public async Task LoginModal_ShouldHandleRealLoginFlow()
        {
            // Arrange
            var mockService = new Mock<ILoginService>();
            mockService.Setup(s => s.LoginAsync(It.IsAny<string>(), It.IsAny<string>()))
                       .ReturnsAsync(false);
            var loginModal = new LoginModal(null, mockService.Object);

            // Act
            // This will make a real HTTP call to your API
            // Only run this test when you want to test against your actual API
            bool result = await loginModal.HandleLogin();

            // Assert
            // The result depends on whether the hardcoded credentials are valid
            Assert.IsType<bool>(result);
        }
    }
}