<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="beans.GuestBookMgr" %>
<%@ page import="beans.GuestBookBean" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>강남대 주변 맛집</title>
    <link rel="stylesheet" href="restaurant.css">
    <meta charset="UTF-8">
</head>
<body>
    
    <div class="banner">
        <img src="image/banner.png" onclick="location.href='gacipan.jsp'" alt="배너 이미지">
    </div>
	
    <button id="login-btn" class="login-button" onclick="location.href='login.jsp'">로그인</button>
	
    <div class="restaurant-list">
        <div class="restaurant">
            <div class="restaurant-image">
                <img src="image/don.jpg" onclick="location.href='Food-don.html'" alt="음식점 1">
            </div>
            <h3>돈불석쇠불고기</h3>
        </div>
        <div class="restaurant">
            <div class="restaurant-image">
                <img src="image/ho.jpg" onclick="location.href='Food-ho.html'" alt="음식점 2">
            </div>
            <h3>호식당 강남대점</h3>
        </div>
        <div class="restaurant">
            <div class="restaurant-image">
                <img src="image/noi.jpg" onclick="location.href='Food-noi.html'" alt="음식점 3">
            </div>
            <h3>노이파스타</h3>
        </div>
        <div class="restaurant">
            <div class="restaurant-image">
                <img src="image/egg.jpg" onclick="location.href='Food-egg.html'" alt="음식점 4">
            </div>
            <h3>알촌</h3>
        </div>
    </div>
  
    <div class="board">
        <h2>맛집 토론 게시판</h2>
    
        <%
        // POST 요청 처리
        if (request.getMethod().equals("POST")) {
            // 폼으로부터 전달된 데이터 추출
            String name = request.getParameter("name");
            String content = request.getParameter("content");

            // 현재 시간 정보 가져오기
            Date now = new Date();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String dateTime = dateFormat.format(now);

            // 게시글 데이터 생성
            GuestBookBean guestBook = new GuestBookBean();
            guestBook.setName(name);
            guestBook.setContent(content);
            guestBook.setDateTime(dateTime);

            // GuestBookMgr 인스턴스 생성
            GuestBookMgr guestBookMgr = new GuestBookMgr();

            // 게시글 추가
            guestBookMgr.addGuestBook(guestBook);

            String comment = request.getParameter("comment");
            String guestBookIdParam = request.getParameter("guestbook_id");
            int guestBookId = -1;
            try {
                guestBookId = Integer.parseInt(guestBookIdParam);
                guestBookMgr.addComment(guestBookId, comment);
            } catch (NumberFormatException e) {
                out.println("댓글 추가 오류: guestbook_id 파라미터를 정수로 변환할 수 없습니다.");
                e.printStackTrace();
            }

            // GuestBookMgr 연결 종료
            guestBookMgr.closeConnection();

            response.sendRedirect("gacipan.jsp"); // 페이지 리로드
        }
        %>

        <%-- 게시글 출력 --%>
        <div style="max-height: 200px; overflow-y: auto; overflow-x: hidden;">
            <h3>게시글 리스트</h3>
            <%
            GuestBookMgr guestBookMgr = new GuestBookMgr();
            Vector<GuestBookBean> guestBookList = guestBookMgr.getGuestBookList();

            if (guestBookList.isEmpty()) {
            %>
            <p>등록된 게시글이 없습니다.</p>
            <%
            } else {
                // DateTime을 기준으로 내림차순으로 게시글 목록을 정렬합니다.
                guestBookList.sort(Comparator.comparing(GuestBookBean::getDateTime).reversed());

                for (GuestBookBean guestBook : guestBookList) {
            %>
            <div>
                <p><b><%= guestBook.getName() %></b> 님의 게시글</p>
                <p><%= guestBook.getContent() %></p>
                <p>작성일시: <%= guestBook.getDateTime() %></p>
                <hr>
                
                <%-- 댓글 표시 --%>
                
                <%
                Vector<String> comments = guestBook.getComments();
                if (comments != null && !comments.isEmpty()) {
                    for (String comment : comments) {
                %>
                <p><%= comment %></p>
                
                <%
                    }
                } else {
                %>
                <p>등록된 댓글이 없습니다.</p>
                <%
                }
                %>
                
                <%-- 댓글 작성 폼 --%>
                <form action="" method="post">
                    <input type="hidden" name="guestbook_id" value="<%= guestBook.getId() %>">
                    <label for="comment">댓글:</label>
                    <input type="text" name="comment" id="comment" required>
                    <input type="submit" value="댓글 작성">
                </form>
            </div>
            <%
                }
            }
            %>
        </div>

        <%-- 게시글 작성 폼 --%>
        <h3>게시글 작성</h3>
        <form action="" method="post">
            <label for="name">이름:</label>
            <input type="text" name="name" id="name" required><br>
            <label for="content">내용:</label>
            <textarea name="content" id="content" rows="4" cols="50" required></textarea><br>
            <input type="submit" value="작성">
        </form>
    </div>

    <script>
        // 사용자가 로그인되었는지 확인합니다.
        var username = localStorage.getItem("username");
        if (username) {
            // 만약 사용자 이름이 로컬 스토리지에 저장되어 있다면, 로그인 버튼의 텍스트를 업데이트합니다.
            document.getElementById("login-btn").innerText = username + "으로 로그인하셨습니다\n로그아웃 하려면 클릭";
        }
    </script>
</body>
</html>
