package com.linguancheng.gdeiassistant.ExceptionHandler;

import org.springframework.beans.TypeMismatchException;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.io.IOException;

@ControllerAdvice(annotations = Controller.class)
public class GlobalControllerAdvice {

    /**
     * 处理HTTP请求400错误
     *
     * @return
     */
    @ExceptionHandler({MissingServletRequestParameterException.class
            , TypeMismatchException.class, HttpMessageNotReadableException.class})
    public void HandleBadRequestException(HttpServletResponse response) throws IOException {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().close();
    }

    /**
     * 处理数据校验异常
     *
     * @return
     */
    @ExceptionHandler({ConstraintViolationException.class
            , MethodArgumentNotValidException.class})
    public void HandleConstraintViolationException(HttpServletResponse response) throws IOException {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().close();
    }
}