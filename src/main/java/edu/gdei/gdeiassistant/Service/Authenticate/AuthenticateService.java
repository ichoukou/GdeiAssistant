package edu.gdei.gdeiassistant.Service.Authenticate;

import edu.gdei.gdeiassistant.Exception.CommonException.NetWorkTimeoutException;
import edu.gdei.gdeiassistant.Exception.CommonException.ServerErrorException;
import edu.gdei.gdeiassistant.Pojo.Entity.CardInfo;
import edu.gdei.gdeiassistant.Pojo.Entity.Identity;
import edu.gdei.gdeiassistant.Pojo.Entity.User;
import edu.gdei.gdeiassistant.Pojo.HttpClient.HttpClientSession;
import edu.gdei.gdeiassistant.Pojo.UserLogin.UserCertificate;
import edu.gdei.gdeiassistant.Repository.Redis.UserCertificate.UserCertificateDao;
import edu.gdei.gdeiassistant.Service.CardQuery.CardQueryService;
import edu.gdei.gdeiassistant.Service.Recognition.RecognitionService;
import edu.gdei.gdeiassistant.Service.UserLogin.UserLoginService;
import edu.gdei.gdeiassistant.Service.YiBan.YiBanAPIService;
import edu.gdei.gdeiassistant.Tools.HttpClientUtils;
import edu.gdei.gdeiassistant.Tools.ImageEncodeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.HttpResponse;
import org.apache.http.client.CookieStore;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.util.EntityUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

@Service
public class AuthenticateService {

    private String url;

    @Autowired
    private UserCertificateDao userCertificateDao;

    @Autowired
    private UserLoginService userLoginService;

    @Autowired
    private RecognitionService recognitionService;

    @Autowired
    private CardQueryService cardQueryService;

    @Autowired
    private YiBanAPIService yiBanAPIService;

    @Value("#{propertiesReader['education.system.url']}")
    public void setUrl(String url) {
        this.url = url;
    }

    private Log log = LogFactory.getLog(AuthenticateService.class);

    private int timeout;

    @Value("#{propertiesReader['timeout.realname']}")
    public void setTimeout(int timeout) {
        this.timeout = timeout;
    }

    /**
     * 从教务系统获取用户身份证号信息
     *
     * @param sessionId
     * @param user
     * @return
     */
    public String GetUserIdentityNumber(String sessionId, User user) throws Exception {
        //检测是否已与教务系统进行会话同步
        UserCertificate userCertificate = userCertificateDao.queryUserCertificate(user.getUsername());
        if (userCertificate == null) {
            //进行会话同步
            userCertificate = userLoginService.SyncUpdateSession(sessionId, user);
            return IdentityNumberQuery(sessionId, user.getUsername()
                    , user.getKeycode(), user.getNumber(), userCertificate.getTimestamp());
        }
        return IdentityNumberQuery(sessionId, userCertificate.getUser().getUsername()
                , userCertificate.getUser().getKeycode(), userCertificate.getUser().getNumber()
                , userCertificate.getTimestamp());
    }

    /**
     * 获取用户真实姓名和学号
     * <p>
     * 该方法调用校园卡基本信息查询的模块获取姓名和学号信息
     *
     * @param sessionId
     * @param username
     * @param password
     * @return
     */
    public Map<String, String> GetAuthenticationInfoBySystem(String sessionId, String username, String password) throws ServerErrorException {
        Map<String, String> resultMap = new HashMap<>();
        CloseableHttpClient httpClient = null;
        CookieStore cookieStore = null;
        try {
            HttpClientSession httpClientSession = HttpClientUtils.getHttpClient(sessionId, true, timeout);
            httpClient = httpClientSession.getCloseableHttpClient();
            cookieStore = httpClientSession.getCookieStore();
            //登录支付管理平台
            cardQueryService.LoginCardSystem(httpClient, username, password, true);
            //获取校园卡基本信息
            CardInfo cardInfo = cardQueryService.QueryCardInformation(httpClient);
            resultMap.put("name", cardInfo.getName());
            resultMap.put("number", cardInfo.getNumber());
            return resultMap;
        } catch (Exception e) {
            log.error("获取用户真实姓名异常：", e);
            throw new ServerErrorException("获取真实姓名异常");
        } finally {
            if (httpClient != null) {
                try {
                    httpClient.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (cookieStore != null) {
                HttpClientUtils.SyncHttpClientCookieStore(sessionId, cookieStore);
            }
        }
    }

    /**
     * 查询身份证号信息
     *
     * @param sessionId
     * @param username
     * @param keycode
     * @param number
     * @param timestamp
     * @return
     */
    private String IdentityNumberQuery(String sessionId, String username, String keycode, String number, Long timestamp) throws Exception {
        CloseableHttpClient httpClient = null;
        CookieStore cookieStore = null;
        try {
            HttpClientSession httpClientSession = HttpClientUtils.getHttpClient(sessionId, true, timeout);
            httpClient = httpClientSession.getCloseableHttpClient();
            cookieStore = httpClientSession.getCookieStore();
            HttpGet httpGet = new HttpGet(url + "cas_verify.aspx?i=" + username + "&k="
                    + keycode + "&timestamp=" + timestamp);
            HttpResponse httpResponse = httpClient.execute(httpGet);
            if (httpResponse.getStatusLine().getStatusCode() == 200) {
                httpGet = new HttpGet(url + "xs_main.aspx?xh=" + number);
                httpResponse = httpClient.execute(httpGet);
                if (httpResponse.getStatusLine().getStatusCode() == 200) {
                    //获取学生的身份证号
                    Document document = Jsoup.parse(EntityUtils.toString(httpResponse.getEntity()));
                    httpGet = new HttpGet(url + "xsgrxx.aspx?xh=" + number);
                    httpGet.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1");
                    httpGet.setHeader("Upgrade-Insecure-Requests", "1");
                    httpGet.setHeader("DNT", "1");
                    httpResponse = httpClient.execute(httpGet);
                    document = Jsoup.parse(EntityUtils.toString(httpResponse.getEntity()));
                    if (httpResponse.getStatusLine().getStatusCode() == 200) {
                        return document.getElementById("lbl_sfzh").text();
                    }
                    throw new ServerErrorException("教务系统异常");
                }
                throw new ServerErrorException("教务系统异常");
            }
            throw new ServerErrorException("教务系统异常");
        } catch (IOException e) {
            log.error("获取用户身份证号码异常：", e);
            throw new NetWorkTimeoutException("网络连接超时");
        } catch (Exception e) {
            log.error("获取用户身份证号码异常：", e);
            throw new ServerErrorException("教务系统一次");
        } finally {
            if (httpClient != null) {
                try {
                    httpClient.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (cookieStore != null) {
                HttpClientUtils.SyncHttpClientCookieStore(sessionId, cookieStore);
            }
        }
    }

    /**
     * 获取易班用户校方认证信息
     *
     * @param accessToken
     * @return
     * @throws ServerErrorException
     */
    public Map<String, String> GetAuthenticationInfoByYiBan(String accessToken) throws ServerErrorException {
        return yiBanAPIService.getYiBanVerifyInfo(accessToken);
    }

    /**
     * 解析身份证图片，获取用户实名信息
     *
     * @param inputStream
     * @return
     */
    public Identity ParseIdentityCardInfo(InputStream inputStream) throws Exception {
        return recognitionService.ParseIdentityCardInfo(ImageEncodeUtils.ConvertToBase64(inputStream));
    }
}
