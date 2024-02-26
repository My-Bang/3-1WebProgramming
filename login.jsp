<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>소셜 로그인 서비스</title>

    <script src="https://accounts.google.com/gsi/client" async defer></script>

    <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
    
    <script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
    
   <style>
        body {
        	background-image: url('image/background.png');
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            
        }
        
         .banner {
  			position: fixed;
        	width: 100%;
        	text-align: center;
        	margin-bottom: 100px;
        	height: 100px;
        	top: 0;
    	}	

        .button-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 20px;
        }

        .button-wrapper a {
            margin-bottom: 10px;
        }

    </style>
    
</head>
<body>

	<div class="banner">
        <img src="image/banner.png" onclick="location.href='gacipan.jsp'" alt="배너 이미지">
    </div>
    
    <h2>소셜 로그인</h2>

    <a href="javascript:void(0)" onclick="signInWithGoogle()">
        <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F99C1FC375C3D83C921" width="300" />
    </a>

    <a id="Kakaobtn" href="javascript:loginWithKakao()">
        <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F996E15375C3D83CA20" width="300" />
    </a>
  
    <a id="Naverbtn" href="javascript:loginWithNaver()">
        <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F995B4C375C3D83CA26" width="300" />
    </a>

    <!-- 페이스북 로그인 버튼 추가 -->
<a href="#" onclick="loginWithFacebook()">
    <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F993B4B375C3D83C91B" alt="페이스북 로그인" width="300" />
</a>


    <script type="text/javascript">
    function loginWithFacebook() {
        FB.login(function(response) {
            if (response.authResponse) {
                // 페이스북 로그인 성공
                console.log('Facebook login successful.');
                statusChangeCallback(response);
            } else {
                // 페이스북 로그인 실패 또는 취소
                console.log('Facebook login failed or cancelled.');
            }
        }, { scope: 'public_profile,email' });
    }

        // 페이스북 로그인 버튼 설정
        window.fbAsyncInit = function() {
            FB.init({
                appId: '220316957460961', // 페이스북 앱 ID로 변경
                cookie: true,
                xfbml: true,
                version: 'v17.0'
            });
            FB.AppEvents.logPageView();
        };

        // 페이스북 SDK 비동기로 로드
        (function(d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = "https://connect.facebook.net/ko_KR/sdk.js";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));

        // 구글, 카카오 로그인 코드...
// 페이스북 로그인 성공 시 호출되는 함수
function statusChangeCallback(response) {
    if (response.status === 'connected') {
        // 사용자가 페이스북에 로그인되어 있는 경우
        console.log('Facebook user is connected.');

        // 사용자 정보 가져오기
        FB.api('/me', { fields: 'name' }, function(response) {
            console.log('Facebook user name: ' + response.name);
            localStorage.setItem('username', response.name);
            window.location.href = 'gacipan.jsp';
        });
    } else {
        // 사용자가 페이스북에 로그인되어 있지 않은 경우
        console.log('Facebook user is not connected.');
    }
}

        // 로그인 - 네이버
        function loginWithNaver() {
            naverLogin.reprompt();
        }

        var naverLogin = new naver.LoginWithNaverId({
            clientId: "kLoO14A6z8Pns3Cksjzn",
            callbackUrl: "http://localhost:8080/myapp/restaurant/naver_callback.html",
        });

        naverLogin.init();

        // 구글 
        function handleCredentialResponse(response) {
            const responsePayload = parseJwt(response.credential);

            console.log("ID: " + responsePayload.sub);
            console.log('Full Name: ' + responsePayload.name);
            console.log('Given Name: ' + responsePayload.given_name);
            console.log('Family Name: ' + responsePayload.family_name);
            console.log("Image URL: " + responsePayload.picture);
            console.log("Email: " + responsePayload.email);

            localStorage.setItem("username", responsePayload.name);
            window.location.href = 'gacipan.jsp';
        }

        function parseJwt(token) {
            var base64Url = token.split('.')[1];
            var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            var jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
            }).join(''));

            return JSON.parse(jsonPayload);
        }

        function signInWithGoogle() {
            google.accounts.id.initialize({
                client_id: '994077007405-75it0s7aerrqq17gcfq7oipj6r3bkbl9.apps.googleusercontent.com',
                callback: handleCredentialResponse
            });
            google.accounts.id.prompt();
        }

        // 카카오
        Kakao.init('715a50e07d28cea530f3b68828a1dd7b');

        function loginWithKakao() {
            Kakao.Auth.login({
                success: function (authObj) {
                    console.log(authObj);
                    Kakao.Auth.setAccessToken(authObj.access_token); 

                    Kakao.API.request({
                        url: '/v2/user/me',
                        success: function (response) {
                            localStorage.setItem("username", response.kakao_account.profile.nickname);
                            window.location.href = 'gacipan.jsp';
                        },
                        fail: function (error) {
                            console.log(error);
                        }
                    });
                },
                fail: function (err) {
                    console.log(err);
                }
            });
        }
        
        // username를 불러온 경우에만 로그아웃 버튼 활성화
        function checkLoggedIn() {
            var username = localStorage.getItem("username");
            if (username) {
                var logoutButton = document.createElement("button");
                logoutButton.className = "logout-btn";
                logoutButton.textContent = "로그아웃";
                logoutButton.onclick = logout;
                document.body.appendChild(logoutButton);
            }
        }

        window.onload = checkLoggedIn;

        // 로그아웃
        function logout() {
            localStorage.removeItem("username");         

            // 구글
            google.accounts.id.disableAutoSelect();
            google.accounts.id.revoke(localStorage.getItem("google_access_token"), logoutCallback);

            // 카카오 
            if (Kakao.Auth.getAccessToken()) {
                Kakao.Auth.setAccessToken(undefined);
                Kakao.Auth.setAccessToken(null);
            }

            // 페이스북
            FB.logout(function(response) {
                console.log(response);
            });

            alert("로그아웃 완료");
        }

        function logoutCallback(response) {
            window.location.href = 'gacipan.jsp';
        }
    </script>
</body>
</html>
