<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta content="telephone=no" name="format-detection">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="black" name="apple-mobile-web-app-status-bar-style">
    <link rel="icon" type="image/png" sizes="192x192" href="/img/favicon/logo.png">
    <link rel="shortcut icon" type="image/png" sizes="64x64" href="/img/favicon/logo.png">
    <title>安全技术规格说明</title>
    <c:if test="${applicationScope.get('grayscale')}">
        <link rel="stylesheet" href="/css/common/grayscale.css">
    </c:if>
</head>
<body>

<div>
    <p style="text-align:center">《广东二师助手安全技术规格说明》</p>
    <p style="text-align:center">更新日期：2019年2月18日</p>
    <p style="text-align:right"><br></p>
    <p style="text-indent:14px;line-height:150%">
    <p><strong>前言</strong></p>
    <p style="text-indent:28px">
        广东二师助手（以下简称“我们”或“应用”）在致力于为在校师生带来便捷、可靠的校园服务的同时，还注重于保护用户的隐私和确保数据的安全。
        《广东二师助手安全技术规格说明》（“本文”）说明了我们使用了哪些主流的安全技术和如何使用这些安全技术来保障你的信息数据安全。
        本文未完全列举广东二师助手使用的所有安全技术，列举的安全技术也未完全说明了所有的技术细节。部分安全技术因涉及知识产权或从系统安全性考虑，可能不会作任何的说明。
    </p>
    <p>&nbsp;</p>
    <p><strong>基础技术</strong></p>
    <p style="text-indent:28px">
        应用的基础技术是模拟登录技术。模拟登录指使用自动化的网络机器人（也被广泛称为“爬虫”）来访问万维网，模拟用户提交请求，接收服务器返回的信息。
        如果有必要，还将会保存服务器返回的数据信息，利用Xpath、正则表达式等技术解析HTTP文档，获取到用户需要的数据，并对其进行相应的加工和修饰，最终呈现给用户。
    </p>
    <p>&nbsp;</p>
    <p><strong>网络通信</strong></p>
    <p style="text-indent:28px">
        （1）HTTPS协议：超文本传输安全协议（英语：Hypertext Transfer Protocol Secure，缩写：HTTPS，常称为HTTP over
        TLS，HTTP over SSL或HTTP
        Secure）是一种通过计算机网络进行安全通信的传输协议。
        HTTPS经由HTTP进行通信，但利用SSL/TLS来加密数据包。HTTPS开发的主要目的，是提供对网站服务器的身份认证，保护交换数据的隐私与完整性。
        这个协议由网景公司（Netscape）在1994年首次提出，随后扩展到互联网上。HTTPS协议要比HTTP协议更加安全，可防止数据在传输过程中不被窃取、改变，确保数据的完整性。
        本站使用Let's Encrypt机构颁发的证书。客户端与本站进行超文本传输的通信已默认启用全局HTTPS，可保证通信过程的数据安全性。</p>
    <p style="text-indent:28px">
        （2）请求防重放攻击校验：重放攻击（Replay
        Attacks）又称重播攻击、回放攻击，是指攻击者发送一个目的主机已接收过的包，来达到欺骗系统的目的，主要用于身份认证过程，破坏认证的正确性。
        重放攻击可以由发起者，也可以由拦截并重发该数据的敌方进行。攻击者利用网络监听或者其他方式盗取认证凭据，之后再把它重新发给认证服务器。
        重放攻击在任何网络通过程中都可能发生，是计算机世界黑客常用的攻击方式之一。应用在用户登录、身份认证和校园卡充值等重要的API接口中，都添加了请求防重放攻击校验机制。
        在客户端发送请求时，会附加上供服务端校验用的时间戳、随机值和消息摘要参数，可以有效地防止重放攻击。</p>
    <p style="text-indent:28px">
        （3）HTTPDNS：HTTPDNS是阿里云面向移动开发者推出的一款域名解析产品，具有域名防劫持、精准调度的特性。
        HTTPDNS使用HTTP协议进行域名解析，代替现有基于UDP的DNS协议，域名解析请求直接发送到阿里云的HTTPDNS服务器，从而绕过运营商的Local DNS，能够避免Local
        DNS造成的域名劫持问题和调度不精准问题。应用的Android和iOS客户端已接入了HTTPDNS，能有效地避免DNS劫持，保证通信安全。</p>
    <p style="text-indent:28px">
        （4）校园卡充值请求的校验和加密：为保障用户的资金安全，校园卡充值相关的API接口使用了多重安全校验和加密措施。除了基础的请求防重放攻击校验、HTTPS网络请求和HTTPDNS解析外，还添加了双向数字签名校验和对称、非对称安全加密的安全机制。 </p>
    <p style="text-indent:28px">
        对称加密算法：对称密钥算法（英语：Symmetric-key
        algorithm）又称为对称加密、私钥加密、共享密钥加密，是密码学中的一类加密算法。这类算法在加密和解密时使用相同的密钥，或是使用两个可以简单地相互推算的密钥。</p>
    <p style="text-indent:28px">
        非对称加密算法：公开密钥密码学（英语：Public-key cryptography），也称为非对称式密码学（英语：asymmetric
        cryptography），是密码学的一种算法，它需要两个密钥，一个是公开密钥，另一个是私有密钥；一个用作加密，另一个则用作解密。使用其中一个密钥把明文加密后所得的密文，只能用相对应的另一个密钥才能解密得到原本的明文；甚至连最初用来加密的密钥也不能用作解密。由于加密和解密需要两个不同的密钥，故被称为非对称加密；不同于加密和解密都使用同一个密钥的对称加密。虽然两个密钥在数学上相关，但如果知道了其中一个，并不能凭此计算出另外一个；因此其中一个可以公开，称为公钥，任意向外发布；不公开的密钥为私钥，必须由用户自行严格秘密保管，绝不透过任何途径向任何人提供，也不会透露给被信任的要通信的另一方。
        基于公开密钥加密的特性，它还提供数字签名的功能，使电子文件可以得到如同在纸本文件上亲笔签署的效果。</p>
    <p style="text-indent:28px">
        消息摘要：密码散列函数（英语：Cryptographic hash
        function），又译为加密散列函数、密码散列函数、加密散列函数，是散列函数的一种。它被认为是一种单向函数，也就是说极其难以由散列函数输出的结果，回推输入的数据是什么。这样的单向函数被称为“现代密码学的驮马”。这种散列函数的输入数据，通常被称为消息（message），而它的输出结果，经常被称为消息摘要（message
        digest）或摘要（digest）。</p>
    <p style="text-indent:28px">
        数字签名：数字签名（又称公钥数字签名，英语：Digital
        Signature）是一种类似写在纸上的普通的物理签名，但是使用了公钥加密领域的技术实现，用于鉴别数字信息的方法。一套数字签名通常定义两种互补的运算，一个用于签名，另一个用于验证，但法条中的电子签章与数字签名，代表之意义并不相同，电子签章用以辨识及确认电子文件签署人身份、资格及电子文件真伪者。而数字签名则是以数学算法或其他方式运算对其加密，才形成的电子签章，意即并非所有的电子签章都是数字签名。</p>
    <p style="text-indent:28px">在提交校园卡充值请求前，客户端会生成一个对称加密的密钥（A）和一对非对称加密的密钥（B），A用于供服务端加密充值结果数据，B用于生成客户端数字签名（E），供服务端校验。</p>
    <p style="text-indent:28px">
        客户端会使用B中的私钥对充值请求参数（包含用户名、金额等，以下简称C）和时间戳、随机值和消息摘要等请求防重放攻击参数（D）一并进行加密得到E，使用服务端提供的非对称公钥（F）对A进行加密得到经非对称加密后的对称加密密钥（G）。</p>
    <p style="text-indent:28px">最终，客户端会将B中的公钥、C、D、E、G参数一并提交给服务端。服务端接收到校园卡充值请求后，首先进行请求防重放攻击校验。</p>
    <p style="text-indent:28px">请求防重放攻击校验通过后，首先通过客户端提供的C、D和B中的公钥，对客户端的E进行校验，保证充值请求未被不法窜改。</p>
    <p style="text-indent:28px">客户端数字签名校验通过后，服务端会使用F解密客户端提供的G得到非对称解密后的对称加密密钥（H，与A具有相同的加解密性质与效果），H用于加密校园卡充值结果数据。</p>
    <p style="text-indent:28px">
        接着，服务端将访问广东第二师范学院支付管理系统，提交校园卡充值订单，最终得到一个订单支付URL和保存有用户身份凭证的Cookies信息（I）。与此同时，应用还将保存一条充值记录在日志数据库中。</p>
    <p style="text-indent:28px">服务端并不会将I明文直接返回给客户端，而是基于I，构造一个新的具有加密数据结构的JSON数据（J），J中的数据模块由加密数据（K）和安全签名（L）两个重要部分组成。</p>
    <p style="text-indent:28px">
        K是为了保证充值结果数据I不被非法监听，通过利用H，将I进行有序序列化后，进行对称加密后得到的一个字符串数据，客户端利用A解密后可以得到I的原文数据。L是为了保证充值结果数据I不被非法篡改，通过利用F，将I进行有序序列化后，进行消息摘要和私钥加密，生成的一个数字签名。</p>
    <p style="text-indent:28px">
        客户端接收到J后，将利用A解密J中的K数据，还原校园卡充值结果数据原文（M，与I相同）。同时也将使用F，解密J中的L数据，并将其与将I进行有序序列化后的消息摘要（N）对比。若两文相符，则表示充值结果数据安全可靠，否则将提示交易存在风险。</p>
    <p style="text-indent:28px"> 只有以上所有的安全加解密、消息摘要、数字签名和安全校验都正确通过后，客户端才会解析返回的充值结果数据，唤起支付宝进行支付，完成校园卡充值。</p>
    <p>&nbsp;</p>
    <p><strong>数据保存</strong></p>
    <p style="text-indent:28px">
        （1）实名认证信息脱敏：为了避免用户实名认证的重要信息（如身份证号、姓名、学号等）被泄露带来不良的影响和后果，我们对所有用户的实名认证信息都进行了脱敏处理，并替代使用用户身份唯一标识符来标记每一名实名用户。</p>
    <p style="text-indent:28px">
        （2）基于对称加密算法的关键用户数据加密存储：在应用数据库中保存的关键用户数据都采用了对称加密进行加密，对称加密算法使用了阿里聚安全提供的安全组件进行实现。安全组件是阿里聚安全提供的一套保障移动平台应用完整性、应用执行环境可信性、数据机密性的专业完整的安全解决方案。</p>
    <p style="text-indent:28px">
        （3）基于子账号和最小权限原则的数据库管理策略：最小权限原则规定：每个用户/任务/应用在必需知情的前提下被赋予明确的访问对象和模块的权限。遵循最小权限原则运行的系统要求授予用户访问对象的明确权限。
        应用将使用一个或多个仅具有其访问的资源所需要的最小权限的，无法使用公共互联网连接访问的子账号来连接和访问数据库资源。</p>
    <p style="text-indent:28px">
        （4）严格的数据访问备案审核和专业的数据安全培训：对于获取和访问数据库数据的请求，包括因法律调查或法律规定或应向我们送达的传票或其他执法部门发出的令状之必要的情况，都需要经过严格的数据访问请求备案和审核，以保证你的数据信息不会被未经备案和审核的请求所获取。
        此外，我们还不定期地为我们的团队、客服、管理员以及第三方合作伙伴开展专业的数据安全课程培训，提升整体数据安全意识。
    </p>
    <p>&nbsp;</p>
    <p><strong>授权认证</strong></p>
    <p style="text-indent:28px">
        （1）JWT：JSON WEB Token，是一种基于JSON的、用于在网络上声明某种主张的令牌（token）。JWT通常由三部分组成: 头信息（header）,
        消息体（payload）和签名（signature）。JWT常常被用作保护服务端的资源（resource），客户端通常将JWT通过HTTP的Authorization
        header发送给服务端，服务端使用自己保存的key计算、验证签名以判断该JWT是否可信。该Token被设计为紧凑且安全的，特别适用于分布式站点的单点登录（SSO）场景。
        JWT的声明一般被用来在身份提供者和服务提供者间传递被认证的用户身份信息，以便于从资源服务器获取资源，也可以增加一些额外的其它业务逻辑所必须的声明信息。
        无状态的JWT具有跨语言支持、便于传输、易于扩展、具一定安全性等特别。为了加强用户对登录凭证的控制，应用使用了有状态的JWT机制。
        应用会将JWT的消息摘要保存到Redis中，用户携带JWT访问Restful API时，应用都会检测Redis中有无该令牌的消息摘要，若不存在，表示该令牌无效（令牌过期或用户主动结束会话）。
        JWT的签名可以有效保证JWT数据不被恶意篡改，应用使用的JWT的签名算法使用了HMAC-SHA256算法。</p>
    <p style="text-indent:28px">HMAC算法：密钥散列消息认证码（英语：Keyed-hash message authentication code），又称散列消息认证码（Hash-based message
        authentication
        code，缩写为HMAC），是一种通过特别计算方式之后产生的消息认证码（MAC），使用密码散列函数，同时结合一个加密密钥。它可以用来保证数据的完整性，同时可以用来作某个消息的身份验证。</p>
    <p style="text-indent: 28px">
        安全散列算法（英语：Secure Hash
        Algorithm，缩写为SHA）是一个密码散列函数家族，是FIPS所认证的安全散列算法。能计算出一个数字消息所对应到的，长度固定的字符串（又称消息摘要）的算法。且若输入的消息不同，它们对应到不同字符串的机率很高。
    </p>
    <p style="text-indent:28px">
        HMAC-SHA算法：HMAC-SHA是从SHA哈希函数构造的一种键控哈希算法，被用作HMAC（基于哈希的消息验证代码）。此HMAC进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
    </p>
    <p style="text-indent:28px">
        （2）OAuth2.0：开放授权（OAuth）是一个开放标准，允许用户让第三方应用访问该用户在某一网站上存储的私密的资源（如照片，视频，联系人列表），而无需将用户名和密码提供给第三方应用。
        OAuth允许用户提供一个令牌，而不是用户名和密码来访问他们存放在特定服务提供者的数据。每一个令牌授权一个特定的网站（例如，视频编辑网站）在特定的时段（例如，接下来的2小时内）内访问特定的资源（例如仅仅是某一相册中的视频）。这样，OAuth让用户可以授权第三方网站访问他们存储在另外服务提供者的某些特定信息，而非所有内容。
    <p style="text-indent:28px">OAuth 2.0是OAuth协议的下一版本，但不向下兼容OAuth 1.0。OAuth
        2.0关注客户端开发者的简易性，同时为Web应用、桌面应用、手机和智能设备提供专门的认证流程。</p>
    <p style="text-indent:28px">
        应用在接入易班网平台时，使用了OAuth
        2.0授权机制，通过易班网提供的授权码，用户无需向应用提供易班网平台的账户与密码，也可以授权应用使用一定的权限，访问用户在易班网平台上的资源和数据，实现如账户绑定、API调用等功能。</p>
    <p style="text-indent: 28px">
        （3）用户登录：用户登录采用了两种认证机制，分别是学院统一认证和应用快速认证。学院统一认证模式将会通过广东第二师范学院统一认证系统进行登录，其优点是能够保证用户登录账号的有效性和实时性，但存在响应缓慢或登录失败的风险。
        为了提高登录响应速度和成功率，用户使用学院统一认证模式登录成功后，应用将在数据库中加密存储用户的账号和密码，以便后期直接使用应用快速认证模式进行登录。应用默认情况下优先使用应用快速认证，若数据库无相关用户账号数据时，才使用学院统一认证模式。
        应用快速认证模式不通过广东第二师范学院统一认证系统进行登录认证，而是直接将用户提交的账户和密码与数据库中加密存储的账号和密码进行比对，若信息匹配，则直接通过登录认证，具有响应速度快的优点，但可能存在账号信息不同步的问题。
        比如，用户于学院统一认证系统修改了账号密码，但未在应用中进行登录同步，则用户使用旧密码进行应用快速认证登录时，仍然能够通过应用快速认证，但只能使用与学院系统无关的功能，如校园树洞、二手交易等，无法使用成绩查询等教务功能。
        只有用户使用修改后的新的账号密码登录应用，应用同步了新的账号密码信息后，用户才可以使用教务相关的功能。由于广东第二师范学院统一认证系统更改了资源访问策略，所有的教务查询请求都需要通过学院统一认证系统登录认证后才可以使用。
        因此，即使用户使用了应用快速认证模式进行登录，应用在后台也会自动地、用户无感知地进行学院统一认证登录，与学院系统进行会话同步，以便用户在访问教务功能资源时，能在第一时间返回数据信息。
    </p>
    <p>&nbsp;</p>
    <p><strong>漏洞防护</strong></p>
    <p style="text-indent:28px">
        （1）跨站脚本攻击：跨站脚本（英语：Cross-site
        scripting，通常简称为：XSS）是一种网站应用程序的安全漏洞攻击，是代码注入的一种。它允许恶意用户将代码注入到网页上，其他用户在观看网页时就会受到影响。这类攻击通常包含了HTML以及用户端脚本语言。
        XSS攻击通常指的是通过利用网页开发时留下的漏洞，通过巧妙的方法注入恶意指令代码到网页，使用户加载并执行攻击者恶意制造的网页程序。这些恶意网页程序通常是JavaScript，但实际上也可以包括Java，VBScript，ActiveX，Flash或者甚至是普通的HTML。攻击成功后，攻击者可能得到更高的权限（如执行一些操作）、私密网页内容、会话和Cookie等各种内容。
        应用使用了用户内容可靠输入验证、参数特征匹配检查、Session标记检查、使用HttpOnly的Cookie等技术手段，能有效抵御常见的XSS攻击。
    </p>
    <p style="text-indent:28px">
        （2）SQL注入攻击：SQL注入（英语：SQL
        injection），也称SQL隐码或SQL注码，是发生于应用程序与数据库层的安全漏洞。简而言之，是在输入的字符串之中注入SQL指令，在设计不良的程序当中忽略了字符检查，那么这些注入进去的恶意指令就会被数据库服务器误认为是正常的SQL指令而运行，因此遭到破坏或是入侵。
        应用使用了输入校验、参数化的SQL语句、针对组合的SQL语句的字符转义等技术手段，能有效抵御常见的SQL注入攻击。
    </p>
    <p style="text-indent:28px">
        （3）跨站请求伪造攻击：跨站请求伪造（英语：Cross-site request forgery），也被称为 one-click attack 或者 session riding，通常缩写为 CSRF 或者 XSRF，
        是一种挟制用户在当前已登录的Web应用程序上执行非本意的操作的攻击方法。跟跨网站脚本（XSS）相比，XSS 利用的是用户对指定网站的信任，CSRF 利用的是网站对用户网页浏览器的信任。
        应用使用了检查Referer字段、添加校验Token等技术手段，能有效抵御常见的CSRF攻击。
    </p>
</div>

</body>
</html>