import http.client


class Response:


    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_LIBRARY_DOC_FORMAT = "ROBOT"
    ROBOT_EXIT_ON_FAILURE = True


    @staticmethod
    def get_token(elem_id):
        conn = http.client.HTTPSConnection(elem_id)
        payload = "-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"grant_type\"\r\n\r\npassword\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"client_id\"\r\n\r\nviax-ui\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"username\"\r\n\r\nrravipati@wiley.com\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"password\"\r\n\r\nHanuman3@\r\n-----011000010111000001101001--\r\n"
        headers = {
            'Content-Type': "multipart/form-data; boundary=---011000010111000001101001",
            'User-Agent': "insomnia/9.3.2",
            'Host': (elem_id),
            'Accept': "application/json",
            'authorization': "Basic dmlheC11aTo="
            }
        conn.request("POST", "/auth/realms/wileyas/protocol/openid-connect/token", payload, headers)
        res = conn.getresponse()
        data = res.read()
        authcode = data.decode("utf-8")
        return authcode
        #print(data.decode("utf-8"))