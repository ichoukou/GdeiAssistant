package edu.gdei.gdeiassistant.Controller.Privacy;

import edu.gdei.gdeiassistant.Pojo.Entity.Privacy;
import edu.gdei.gdeiassistant.Pojo.Result.DataJsonResult;
import edu.gdei.gdeiassistant.Service.Privacy.PrivacyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

@Controller
public class PrivacyController {

    @Autowired
    private PrivacyService privacyService;

    /**
     * 进入隐私设置界面
     *
     * @return
     */
    @RequestMapping(value = {"/privacy", "/yiban/privacy"}, method = RequestMethod.GET)
    public ModelAndView ResolvePrivacySettingPage() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("Profile/privacy");
        return modelAndView;
    }

    /**
     * 获取用户隐私设置
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/rest/privacy", method = RequestMethod.GET)
    @ResponseBody
    public DataJsonResult<Privacy> GetUserPrivacySetting(HttpServletRequest request) throws Exception {
        DataJsonResult<Privacy> result = new DataJsonResult<>();
        String username = (String) request.getSession().getAttribute("username");
        Privacy privacy = privacyService.GetPrivacySetting(username);
        if (privacy != null) {
            result.setData(privacy);
            result.setSuccess(true);
        }

        return result;
    }

    /**
     * 更新用户隐私设置
     *
     * @param request
     * @param index
     * @param state
     * @return
     */
    @RequestMapping(value = "/rest/privacy", method = RequestMethod.POST)
    @ResponseBody
    public DataJsonResult<Privacy> UpdateUserPrivacySetting(HttpServletRequest request, int index, boolean state) {
        DataJsonResult<Privacy> result = new DataJsonResult<>();
        String username = (String) request.getSession().getAttribute("username");
        if (username == null || username.trim().isEmpty()) {
            result.setSuccess(false);
            result.setMessage("用户身份凭证过期，请稍候再试");
        } else {
            switch (index) {
                case 0:
                    //性别
                    if (privacyService.UpdateGender(state, username)) {
                        result.setSuccess(true);
                    } else {
                        result.setSuccess(false);
                        result.setMessage("服务器异常，请稍候再试");
                    }
                    break;

                case 1:
                    //性取向
                    if (privacyService.UpdateGenderOrientation(state, username)) {
                        result.setSuccess(true);
                    } else {
                        result.setSuccess(false);
                        result.setMessage("服务器异常，请稍候再试");
                    }
                    break;

                case 2:
                    //院系
                    if (privacyService.UpdateFaculty(state, username)) {
                        result.setSuccess(true);
                    } else {
                        result.setSuccess(false);
                        result.setMessage("服务器异常，请稍后再试");
                    }
                    break;

                case 3:
                    //专业
                    if (privacyService.UpdateMajor(state, username)) {
                        result.setSuccess(true);
                    } else {
                        result.setSuccess(false);
                        result.setMessage("服务器异常，请稍后再试");
                    }
                    break;

                case 4:
                    //所在地
                    if (privacyService.UpdateLocation(state, username)) {
                        result.setSuccess(true);
                    } else {
                        result.setSuccess(false);
                        result.setMessage("服务器异常，请稍候再试");
                    }
                    break;

                case 5:
                    //个人简介
                    if (privacyService.UpdateIntroduction(state, username)) {
                        result.setSuccess(true);
                    } else {
                        result.setSuccess(false);
                        result.setMessage("服务器异常，请稍候再试");
                    }
                    break;

                case 6:
                    //教务数据
                    if (privacyService.UpdateCache(state, username)) {
                        result.setSuccess(true);
                    } else {
                        result.setSuccess(false);
                        result.setMessage("服务器异常，请稍候再试");
                    }
                    break;

                default:
                    result.setSuccess(false);
                    result.setMessage("请求参数不合法");
                    break;
            }
        }
        return result;
    }
}
