



<!DOCTYPE html>
<html lang="en" class=" is-copy-enabled is-u2f-enabled">
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# object: http://ogp.me/ns/object# article: http://ogp.me/ns/article# profile: http://ogp.me/ns/profile#">
    <meta charset='utf-8'>
    

    <link crossorigin="anonymous" href="https://assets-cdn.github.com/assets/frameworks-f58b8d6de8bc9fde24688085829036adf401072bd89acbbe4897816112552904.css" integrity="sha256-9YuNbei8n94kaICFgpA2rfQBByvYmsu+SJeBYRJVKQQ=" media="all" rel="stylesheet" />
    <link crossorigin="anonymous" href="https://assets-cdn.github.com/assets/github-fdb2407fecf3baa8ae269dd4233bd00902837267eaba4424be96b8213c5fcb03.css" integrity="sha256-/bJAf+zzuqiuJp3UIzvQCQKDcmfqukQkvpa4ITxfywM=" media="all" rel="stylesheet" />
    
    
    
    

    <link as="script" href="https://assets-cdn.github.com/assets/frameworks-88471af1fec40ff9418efbe2ddd15b6896af8d772f8179004c254dffc25ea490.js" rel="preload" />
    
    <link as="script" href="https://assets-cdn.github.com/assets/github-9f5b3513fc385beee7bbc7ade384c8327333c6714c828ca98c2e2023a5fc256e.js" rel="preload" />

    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Content-Language" content="en">
    <meta name="viewport" content="width=device-width">
    
    <title>Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/PA1_template.md at master · UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub">
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub">
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="/apple-touch-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="/apple-touch-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="/apple-touch-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="/apple-touch-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon-180x180.png">
    <meta property="fb:app_id" content="1401488693436528">

      <meta content="https://avatars0.githubusercontent.com/u/7246712?v=3&amp;s=400" name="twitter:image:src" /><meta content="@github" name="twitter:site" /><meta content="summary" name="twitter:card" /><meta content="UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera" name="twitter:title" /><meta content="Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera - Notes and Quiz Answers of Reproducible Research Coursera Course" name="twitter:description" />
      <meta content="https://avatars0.githubusercontent.com/u/7246712?v=3&amp;s=400" property="og:image" /><meta content="GitHub" property="og:site_name" /><meta content="object" property="og:type" /><meta content="UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera" property="og:title" /><meta content="https://github.com/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera" property="og:url" /><meta content="Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera - Notes and Quiz Answers of Reproducible Research Coursera Course" property="og:description" />
      <meta name="browser-stats-url" content="https://api.github.com/_private/browser/stats">
    <meta name="browser-errors-url" content="https://api.github.com/_private/browser/errors">
    <link rel="assets" href="https://assets-cdn.github.com/">
    <link rel="web-socket" href="wss://live.github.com/_sockets/ODQxNTAzNTo4OTIwNTM1NzEwZDk0MDBiN2RlZmZkNDFmMDUzM2I5ODoxNjlkOWQwYWUxOTM1YzdiYzdiMTJhYTFmMDE2NzMyMDRlODI1NmM3YzkwNmZhZGJlZTI4OTY0MDQ5MWJlN2U4--89c60b4ee7496eb024d92c3a2c8bc36cc4bafd12">
    <meta name="pjax-timeout" content="1000">
    <link rel="sudo-modal" href="/sessions/sudo_modal">
    <meta name="request-id" content="CA87EEC8:0317:354BC24:57D64501" data-pjax-transient>

    <meta name="msapplication-TileImage" content="/windows-tile.png">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="selected-link" value="repo_source" data-pjax-transient>

    <meta name="google-site-verification" content="KT5gs8h0wvaagLKAVWq8bbeNwnZZK1r1XQysX3xurLU">
<meta name="google-site-verification" content="ZzhVyEFwb7w3e0-uOTltm8Jsck2F5StVihD0exw2fsA">
    <meta name="google-analytics" content="UA-3769691-2">

<meta content="collector.githubapp.com" name="octolytics-host" /><meta content="github" name="octolytics-app-id" /><meta content="CA87EEC8:0317:354BC24:57D64501" name="octolytics-dimension-request_id" /><meta content="8415035" name="octolytics-actor-id" /><meta content="Avighan" name="octolytics-actor-login" /><meta content="435e2a420115695fa151f1d3c4b0212355268e73cf91d3f0ba558177a2cf5902" name="octolytics-actor-hash" />
<meta content="/&lt;user-name&gt;/&lt;repo-name&gt;/blob/show" data-pjax-transient="true" name="analytics-location" />



  <meta class="js-ga-set" name="dimension1" content="Logged In">



        <meta name="hostname" content="github.com">
    <meta name="user-login" content="Avighan">

        <meta name="expected-hostname" content="github.com">
      <meta name="js-proxy-site-detection-payload" content="YjBmYjE4ZjExMThiZjliYzhjZTZlNDdlNmI1YjRmZjFlMzk2ODIwZDk3NjU1Zjk4ZTNmNWFmYzIzOTY0MDMxNXx7InJlbW90ZV9hZGRyZXNzIjoiMjAyLjEzNS4yMzguMjAwIiwicmVxdWVzdF9pZCI6IkNBODdFRUM4OjAzMTc6MzU0QkMyNDo1N0Q2NDUwMSIsInRpbWVzdGFtcCI6MTQ3MzY2MDE2N30=">


      <link rel="mask-icon" href="https://assets-cdn.github.com/pinned-octocat.svg" color="#4078c0">
      <link rel="icon" type="image/x-icon" href="https://assets-cdn.github.com/favicon.ico">

    <meta name="html-safe-nonce" content="e46e3732bfc3a636a9f8da9241242443bd6ada2b">
    <meta content="f934ea0f0e02464d419648201788eb473d8c0167" name="form-nonce" />

    <meta http-equiv="x-pjax-version" content="59e36a4fa0e926950d12544311a4afa1">
    

      
  <meta name="description" content="Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera - Notes and Quiz Answers of Reproducible Research Coursera Course">
  <meta name="go-import" content="github.com/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera git https://github.com/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera.git">

  <meta content="7246712" name="octolytics-dimension-user_id" /><meta content="UtkarshPathrabe" name="octolytics-dimension-user_login" /><meta content="25111628" name="octolytics-dimension-repository_id" /><meta content="UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera" name="octolytics-dimension-repository_nwo" /><meta content="true" name="octolytics-dimension-repository_public" /><meta content="false" name="octolytics-dimension-repository_is_fork" /><meta content="25111628" name="octolytics-dimension-repository_network_root_id" /><meta content="UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera" name="octolytics-dimension-repository_network_root_nwo" />
  <link href="https://github.com/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/commits/master.atom" rel="alternate" title="Recent Commits to Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera:master" type="application/atom+xml">


      <link rel="canonical" href="https://github.com/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/blob/master/Project%2001/PA1_template.md" data-pjax-transient>
  </head>


  <body class="logged-in  env-production windows vis-public page-blob">
    <div id="js-pjax-loader-bar" class="pjax-loader-bar"><div class="progress"></div></div>
    <a href="#start-of-content" tabindex="1" class="accessibility-aid js-skip-to-content">Skip to content</a>

    
    
    



        <div class="header header-logged-in true" role="banner">
  <div class="container clearfix">

    <a class="header-logo-invertocat" href="https://github.com/" data-hotkey="g d" aria-label="Homepage" data-ga-click="Header, go to dashboard, icon:logo">
  <svg aria-hidden="true" class="octicon octicon-mark-github" height="28" version="1.1" viewBox="0 0 16 16" width="28"><path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z"></path></svg>
</a>


        <div class="header-search scoped-search site-scoped-search js-site-search" role="search">
  <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/search" class="js-site-search-form" data-scoped-search-url="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/search" data-unscoped-search-url="/search" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div>
    <label class="form-control header-search-wrapper js-chromeless-input-container">
      <div class="header-search-scope">This repository</div>
      <input type="text"
        class="form-control header-search-input js-site-search-focus js-site-search-field is-clearable"
        data-hotkey="s"
        name="q"
        placeholder="Search"
        aria-label="Search this repository"
        data-unscoped-placeholder="Search GitHub"
        data-scoped-placeholder="Search"
        autocapitalize="off">
    </label>
</form></div>


      <ul class="header-nav float-left" role="navigation">
        <li class="header-nav-item">
          <a href="/pulls" aria-label="Pull requests you created" class="js-selected-navigation-item header-nav-link" data-ga-click="Header, click, Nav menu - item:pulls context:user" data-hotkey="g p" data-selected-links="/pulls /pulls/assigned /pulls/mentioned /pulls">
            Pull requests
</a>        </li>
        <li class="header-nav-item">
          <a href="/issues" aria-label="Issues you created" class="js-selected-navigation-item header-nav-link" data-ga-click="Header, click, Nav menu - item:issues context:user" data-hotkey="g i" data-selected-links="/issues /issues/assigned /issues/mentioned /issues">
            Issues
</a>        </li>
          <li class="header-nav-item">
            <a class="header-nav-link" href="https://gist.github.com/" data-ga-click="Header, go to gist, text:gist">Gist</a>
          </li>
      </ul>

    
<ul class="header-nav user-nav float-right" id="user-links">
  <li class="header-nav-item">
    
    <a href="/notifications" aria-label="You have no unread notifications" class="header-nav-link notification-indicator tooltipped tooltipped-s js-socket-channel js-notification-indicator" data-channel="tenant:1:notification-changed:8415035" data-ga-click="Header, go to notifications, icon:read" data-hotkey="g n">
        <span class="mail-status "></span>
        <svg aria-hidden="true" class="octicon octicon-bell" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path d="M14 12v1H0v-1l.73-.58c.77-.77.81-2.55 1.19-4.42C2.69 3.23 6 2 6 2c0-.55.45-1 1-1s1 .45 1 1c0 0 3.39 1.23 4.16 5 .38 1.88.42 3.66 1.19 4.42l.66.58H14zm-7 4c1.11 0 2-.89 2-2H5c0 1.11.89 2 2 2z"></path></svg>
</a>
  </li>

  <li class="header-nav-item dropdown js-menu-container">
    <a class="header-nav-link tooltipped tooltipped-s js-menu-target" href="/new"
       aria-label="Create new…"
       data-ga-click="Header, create new, icon:add">
      <svg aria-hidden="true" class="octicon octicon-plus float-left" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path d="M12 9H7v5H5V9H0V7h5V2h2v5h5z"></path></svg>
      <span class="dropdown-caret"></span>
    </a>

    <div class="dropdown-menu-content js-menu-content">
      <ul class="dropdown-menu dropdown-menu-sw">
        
<a class="dropdown-item" href="/new" data-ga-click="Header, create new repository">
  New repository
</a>

  <a class="dropdown-item" href="/new/import" data-ga-click="Header, import a repository">
    Import repository
  </a>


  <a class="dropdown-item" href="/organizations/new" data-ga-click="Header, create new organization">
    New organization
  </a>



  <div class="dropdown-divider"></div>
  <div class="dropdown-header">
    <span title="UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera">This repository</span>
  </div>
    <a class="dropdown-item" href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/issues/new" data-ga-click="Header, create new issue">
      New issue
    </a>

      </ul>
    </div>
  </li>

  <li class="header-nav-item dropdown js-menu-container">
    <a class="header-nav-link name tooltipped tooltipped-sw js-menu-target" href="/Avighan"
       aria-label="View profile and more"
       data-ga-click="Header, show menu, icon:avatar">
      <img alt="@Avighan" class="avatar" height="20" src="https://avatars3.githubusercontent.com/u/8415035?v=3&amp;s=40" width="20" />
      <span class="dropdown-caret"></span>
    </a>

    <div class="dropdown-menu-content js-menu-content">
      <div class="dropdown-menu dropdown-menu-sw">
        <div class="dropdown-header header-nav-current-user css-truncate">
          Signed in as <strong class="css-truncate-target">Avighan</strong>
        </div>

        <div class="dropdown-divider"></div>

        <a class="dropdown-item" href="/Avighan" data-ga-click="Header, go to profile, text:your profile">
          Your profile
        </a>
          <a class="dropdown-item" href="/stars" data-ga-click="Header, go to starred repos, text:your stars">
            Your stars
          </a>
        <a class="dropdown-item" href="/explore" data-ga-click="Header, go to explore, text:explore">
          Explore
        </a>
          <a class="dropdown-item" href="/integrations" data-ga-click="Header, go to integrations, text:integrations">
            Integrations
          </a>
        <a class="dropdown-item" href="https://help.github.com" data-ga-click="Header, go to help, text:help">
          Help
        </a>


        <div class="dropdown-divider"></div>

        <a class="dropdown-item" href="/settings/profile" data-ga-click="Header, go to settings, icon:settings">
          Settings
        </a>

        <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/logout" class="logout-form" data-form-nonce="f934ea0f0e02464d419648201788eb473d8c0167" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="8bfpFw3mt9FNKNLJ+TG6EFCp+Ho7Hl9umb0eW7t+JPKgq0SpF5FoUmmtNoZLeV10xAy7Va0Wbq3ZGiiNRmKmMA==" /></div>
          <button class="dropdown-item dropdown-signout" data-ga-click="Header, sign out, icon:logout">
            Sign out
          </button>
</form>      </div>
    </div>
  </li>
</ul>


    
  </div>
</div>


      


    <div id="start-of-content" class="accessibility-aid"></div>

      <div id="js-flash-container">
</div>


    <div role="main">
        <div itemscope itemtype="http://schema.org/SoftwareSourceCode">
    <div id="js-repo-pjax-container" data-pjax-container>
      
<div class="pagehead repohead instapaper_ignore readability-menu experiment-repo-nav">
  <div class="container repohead-details-container">

    

<ul class="pagehead-actions">

  <li>
        <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/notifications/subscribe" class="js-social-container" data-autosubmit="true" data-form-nonce="f934ea0f0e02464d419648201788eb473d8c0167" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="TkGb7Os3sa3D2K37XIiMjs1CacTtkKsEAr706rJBB5TCsr7GMWwyvSonjyQRlwjE53wpagmGWafWLREAc9NH5w==" /></div>      <input class="form-control" id="repository_id" name="repository_id" type="hidden" value="25111628" />

        <div class="select-menu js-menu-container js-select-menu">
          <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/subscription"
            class="btn btn-sm btn-with-count select-menu-button js-menu-target" role="button" tabindex="0" aria-haspopup="true"
            data-ga-click="Repository, click Watch settings, action:blob#show">
            <span class="js-select-button">
              <svg aria-hidden="true" class="octicon octicon-eye" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M8.06 2C3 2 0 8 0 8s3 6 8.06 6C13 14 16 8 16 8s-3-6-7.94-6zM8 12c-2.2 0-4-1.78-4-4 0-2.2 1.8-4 4-4 2.22 0 4 1.8 4 4 0 2.22-1.78 4-4 4zm2-4c0 1.11-.89 2-2 2-1.11 0-2-.89-2-2 0-1.11.89-2 2-2 1.11 0 2 .89 2 2z"></path></svg>
              Watch
            </span>
          </a>
          <a class="social-count js-social-count"
            href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/watchers"
            aria-label="1 user is watching this repository">
            1
          </a>

        <div class="select-menu-modal-holder">
          <div class="select-menu-modal subscription-menu-modal js-menu-content" aria-hidden="true">
            <div class="select-menu-header js-navigation-enable" tabindex="-1">
              <svg aria-label="Close" class="octicon octicon-x js-menu-close" height="16" role="img" version="1.1" viewBox="0 0 12 16" width="12"><path d="M7.48 8l3.75 3.75-1.48 1.48L6 9.48l-3.75 3.75-1.48-1.48L4.52 8 .77 4.25l1.48-1.48L6 6.52l3.75-3.75 1.48 1.48z"></path></svg>
              <span class="select-menu-title">Notifications</span>
            </div>

              <div class="select-menu-list js-navigation-container" role="menu">

                <div class="select-menu-item js-navigation-item selected" role="menuitem" tabindex="0">
                  <svg aria-hidden="true" class="octicon octicon-check select-menu-item-icon" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path d="M12 5l-8 8-4-4 1.5-1.5L4 10l6.5-6.5z"></path></svg>
                  <div class="select-menu-item-text">
                    <input checked="checked" id="do_included" name="do" type="radio" value="included" />
                    <span class="select-menu-item-heading">Not watching</span>
                    <span class="description">Be notified when participating or @mentioned.</span>
                    <span class="js-select-button-text hidden-select-button-text">
                      <svg aria-hidden="true" class="octicon octicon-eye" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M8.06 2C3 2 0 8 0 8s3 6 8.06 6C13 14 16 8 16 8s-3-6-7.94-6zM8 12c-2.2 0-4-1.78-4-4 0-2.2 1.8-4 4-4 2.22 0 4 1.8 4 4 0 2.22-1.78 4-4 4zm2-4c0 1.11-.89 2-2 2-1.11 0-2-.89-2-2 0-1.11.89-2 2-2 1.11 0 2 .89 2 2z"></path></svg>
                      Watch
                    </span>
                  </div>
                </div>

                <div class="select-menu-item js-navigation-item " role="menuitem" tabindex="0">
                  <svg aria-hidden="true" class="octicon octicon-check select-menu-item-icon" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path d="M12 5l-8 8-4-4 1.5-1.5L4 10l6.5-6.5z"></path></svg>
                  <div class="select-menu-item-text">
                    <input id="do_subscribed" name="do" type="radio" value="subscribed" />
                    <span class="select-menu-item-heading">Watching</span>
                    <span class="description">Be notified of all conversations.</span>
                    <span class="js-select-button-text hidden-select-button-text">
                      <svg aria-hidden="true" class="octicon octicon-eye" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M8.06 2C3 2 0 8 0 8s3 6 8.06 6C13 14 16 8 16 8s-3-6-7.94-6zM8 12c-2.2 0-4-1.78-4-4 0-2.2 1.8-4 4-4 2.22 0 4 1.8 4 4 0 2.22-1.78 4-4 4zm2-4c0 1.11-.89 2-2 2-1.11 0-2-.89-2-2 0-1.11.89-2 2-2 1.11 0 2 .89 2 2z"></path></svg>
                      Unwatch
                    </span>
                  </div>
                </div>

                <div class="select-menu-item js-navigation-item " role="menuitem" tabindex="0">
                  <svg aria-hidden="true" class="octicon octicon-check select-menu-item-icon" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path d="M12 5l-8 8-4-4 1.5-1.5L4 10l6.5-6.5z"></path></svg>
                  <div class="select-menu-item-text">
                    <input id="do_ignore" name="do" type="radio" value="ignore" />
                    <span class="select-menu-item-heading">Ignoring</span>
                    <span class="description">Never be notified.</span>
                    <span class="js-select-button-text hidden-select-button-text">
                      <svg aria-hidden="true" class="octicon octicon-mute" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M8 2.81v10.38c0 .67-.81 1-1.28.53L3 10H1c-.55 0-1-.45-1-1V7c0-.55.45-1 1-1h2l3.72-3.72C7.19 1.81 8 2.14 8 2.81zm7.53 3.22l-1.06-1.06-1.97 1.97-1.97-1.97-1.06 1.06L11.44 8 9.47 9.97l1.06 1.06 1.97-1.97 1.97 1.97 1.06-1.06L13.56 8l1.97-1.97z"></path></svg>
                      Stop ignoring
                    </span>
                  </div>
                </div>

              </div>

            </div>
          </div>
        </div>
</form>
  </li>

  <li>
    
  <div class="js-toggler-container js-social-container starring-container ">

    <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/unstar" class="starred" data-form-nonce="f934ea0f0e02464d419648201788eb473d8c0167" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="EgPzc9xzbHadG1Op/Es9COkvA6L4v5JxYSRmvL/5+Za5AP8qgbeOZZvTDjJ3fnly4czBAqpvxGNbPMs0fAkxhg==" /></div>
      <button
        class="btn btn-sm btn-with-count js-toggler-target"
        aria-label="Unstar this repository" title="Unstar UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera"
        data-ga-click="Repository, click unstar button, action:blob#show; text:Unstar">
        <svg aria-hidden="true" class="octicon octicon-star" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74z"></path></svg>
        Unstar
      </button>
        <a class="social-count js-social-count" href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/stargazers"
           aria-label="0 users starred this repository">
          0
        </a>
</form>
    <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/star" class="unstarred" data-form-nonce="f934ea0f0e02464d419648201788eb473d8c0167" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="LUjliCUgZGYGaljKE48BNFyMUKXuxEpqoLVqJCZgEAvhkWxZ6QGKj81H/3yml3VdAnse+vFJuCQvmW+ARN91lg==" /></div>
      <button
        class="btn btn-sm btn-with-count js-toggler-target"
        aria-label="Star this repository" title="Star UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera"
        data-ga-click="Repository, click star button, action:blob#show; text:Star">
        <svg aria-hidden="true" class="octicon octicon-star" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74z"></path></svg>
        Star
      </button>
        <a class="social-count js-social-count" href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/stargazers"
           aria-label="0 users starred this repository">
          0
        </a>
</form>  </div>

  </li>

  <li>
          <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/fork" class="btn-with-count" data-form-nonce="f934ea0f0e02464d419648201788eb473d8c0167" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="XVOcSJKcpl6vz2HL8AkcylGFycJCZBCkbY+lfDgYHN3CFuCinhalP3aiS4ghx/FuKUSCD+zZNPm9zC7OEuydsQ==" /></div>
            <button
                type="submit"
                class="btn btn-sm btn-with-count"
                data-ga-click="Repository, show fork modal, action:blob#show; text:Fork"
                title="Fork your own copy of UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera to your account"
                aria-label="Fork your own copy of UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera to your account">
              <svg aria-hidden="true" class="octicon octicon-repo-forked" height="16" version="1.1" viewBox="0 0 10 16" width="10"><path d="M8 1a1.993 1.993 0 0 0-1 3.72V6L5 8 3 6V4.72A1.993 1.993 0 0 0 2 1a1.993 1.993 0 0 0-1 3.72V6.5l3 3v1.78A1.993 1.993 0 0 0 5 15a1.993 1.993 0 0 0 1-3.72V9.5l3-3V4.72A1.993 1.993 0 0 0 8 1zM2 4.2C1.34 4.2.8 3.65.8 3c0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3 10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3-10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2z"></path></svg>
              Fork
            </button>
</form>
    <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/network" class="social-count"
       aria-label="10 users are forked this repository">
      10
    </a>
  </li>
</ul>

    <h1 class="public ">
  <svg aria-hidden="true" class="octicon octicon-repo" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path d="M4 9H3V8h1v1zm0-3H3v1h1V6zm0-2H3v1h1V4zm0-2H3v1h1V2zm8-1v12c0 .55-.45 1-1 1H6v2l-1.5-1.5L3 16v-2H1c-.55 0-1-.45-1-1V1c0-.55.45-1 1-1h10c.55 0 1 .45 1 1zm-1 10H1v2h2v-1h3v1h5v-2zm0-10H2v9h9V1z"></path></svg>
  <span class="author" itemprop="author"><a href="/UtkarshPathrabe" class="url fn" rel="author">UtkarshPathrabe</a></span><!--
--><span class="path-divider">/</span><!--
--><strong itemprop="name"><a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera" data-pjax="#js-repo-pjax-container">Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera</a></strong>

</h1>

  </div>
  <div class="container">
    
<nav class="reponav js-repo-nav js-sidenav-container-pjax"
     itemscope
     itemtype="http://schema.org/BreadcrumbList"
     role="navigation"
     data-pjax="#js-repo-pjax-container">

  <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
    <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera" aria-selected="true" class="js-selected-navigation-item selected reponav-item" data-hotkey="g c" data-selected-links="repo_source repo_downloads repo_commits repo_releases repo_tags repo_branches /UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera" itemprop="url">
      <svg aria-hidden="true" class="octicon octicon-code" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path d="M9.5 3L8 4.5 11.5 8 8 11.5 9.5 13 14 8 9.5 3zm-5 0L0 8l4.5 5L6 11.5 2.5 8 6 4.5 4.5 3z"></path></svg>
      <span itemprop="name">Code</span>
      <meta itemprop="position" content="1">
</a>  </span>

    <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
      <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/issues" class="js-selected-navigation-item reponav-item" data-hotkey="g i" data-selected-links="repo_issues repo_labels repo_milestones /UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/issues" itemprop="url">
        <svg aria-hidden="true" class="octicon octicon-issue-opened" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path d="M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"></path></svg>
        <span itemprop="name">Issues</span>
        <span class="counter">0</span>
        <meta itemprop="position" content="2">
</a>    </span>

  <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
    <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/pulls" class="js-selected-navigation-item reponav-item" data-hotkey="g p" data-selected-links="repo_pulls /UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/pulls" itemprop="url">
      <svg aria-hidden="true" class="octicon octicon-git-pull-request" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path d="M11 11.28V5c-.03-.78-.34-1.47-.94-2.06C9.46 2.35 8.78 2.03 8 2H7V0L4 3l3 3V4h1c.27.02.48.11.69.31.21.2.3.42.31.69v6.28A1.993 1.993 0 0 0 10 15a1.993 1.993 0 0 0 1-3.72zm-1 2.92c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zM4 3c0-1.11-.89-2-2-2a1.993 1.993 0 0 0-1 3.72v6.56A1.993 1.993 0 0 0 2 15a1.993 1.993 0 0 0 1-3.72V4.72c.59-.34 1-.98 1-1.72zm-.8 10c0 .66-.55 1.2-1.2 1.2-.65 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2zM2 4.2C1.34 4.2.8 3.65.8 3c0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2z"></path></svg>
      <span itemprop="name">Pull requests</span>
      <span class="counter">0</span>
      <meta itemprop="position" content="3">
</a>  </span>


    <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/wiki" class="js-selected-navigation-item reponav-item" data-hotkey="g w" data-selected-links="repo_wiki /UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/wiki">
      <svg aria-hidden="true" class="octicon octicon-book" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M3 5h4v1H3V5zm0 3h4V7H3v1zm0 2h4V9H3v1zm11-5h-4v1h4V5zm0 2h-4v1h4V7zm0 2h-4v1h4V9zm2-6v9c0 .55-.45 1-1 1H9.5l-1 1-1-1H2c-.55 0-1-.45-1-1V3c0-.55.45-1 1-1h5.5l1 1 1-1H15c.55 0 1 .45 1 1zm-8 .5L7.5 3H2v9h6V3.5zm7-.5H9.5l-.5.5V12h6V3z"></path></svg>
      Wiki
</a>

  <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/pulse" class="js-selected-navigation-item reponav-item" data-selected-links="pulse /UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/pulse">
    <svg aria-hidden="true" class="octicon octicon-pulse" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path d="M11.5 8L8.8 5.4 6.6 8.5 5.5 1.6 2.38 8H0v2h3.6l.9-1.8.9 5.4L9 8.5l1.6 1.5H14V8z"></path></svg>
    Pulse
</a>
  <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/graphs" class="js-selected-navigation-item reponav-item" data-selected-links="repo_graphs repo_contributors /UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/graphs">
    <svg aria-hidden="true" class="octicon octicon-graph" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M16 14v1H0V0h1v14h15zM5 13H3V8h2v5zm4 0H7V3h2v10zm4 0h-2V6h2v7z"></path></svg>
    Graphs
</a>

</nav>

  </div>
</div>

<div class="container new-discussion-timeline experiment-repo-nav">
  <div class="repository-content">

    

<a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/blob/86d30498da3a98223ac7d8b02a50448403772274/Project%2001/PA1_template.md" class="d-none js-permalink-shortcut" data-hotkey="y">Permalink</a>

<!-- blob contrib key: blob_contributors:v21:4432282420ba2c0bcfeae2032ab44d96 -->

<div class="file-navigation js-zeroclipboard-container">
  
<div class="select-menu branch-select-menu js-menu-container js-select-menu float-left">
  <button class="btn btn-sm select-menu-button js-menu-target css-truncate" data-hotkey="w"
    
    type="button" aria-label="Switch branches or tags" tabindex="0" aria-haspopup="true">
    <i>Branch:</i>
    <span class="js-select-button css-truncate-target">master</span>
  </button>

  <div class="select-menu-modal-holder js-menu-content js-navigation-container" data-pjax aria-hidden="true">

    <div class="select-menu-modal">
      <div class="select-menu-header">
        <svg aria-label="Close" class="octicon octicon-x js-menu-close" height="16" role="img" version="1.1" viewBox="0 0 12 16" width="12"><path d="M7.48 8l3.75 3.75-1.48 1.48L6 9.48l-3.75 3.75-1.48-1.48L4.52 8 .77 4.25l1.48-1.48L6 6.52l3.75-3.75 1.48 1.48z"></path></svg>
        <span class="select-menu-title">Switch branches/tags</span>
      </div>

      <div class="select-menu-filters">
        <div class="select-menu-text-filter">
          <input type="text" aria-label="Filter branches/tags" id="context-commitish-filter-field" class="form-control js-filterable-field js-navigation-enable" placeholder="Filter branches/tags">
        </div>
        <div class="select-menu-tabs">
          <ul>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="branches" data-filter-placeholder="Filter branches/tags" class="js-select-menu-tab" role="tab">Branches</a>
            </li>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="tags" data-filter-placeholder="Find a tag…" class="js-select-menu-tab" role="tab">Tags</a>
            </li>
          </ul>
        </div>
      </div>

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="branches" role="menu">

        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


            <a class="select-menu-item js-navigation-item js-navigation-open selected"
               href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/blob/master/Project%2001/PA1_template.md"
               data-name="master"
               data-skip-pjax="true"
               rel="nofollow">
              <svg aria-hidden="true" class="octicon octicon-check select-menu-item-icon" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path d="M12 5l-8 8-4-4 1.5-1.5L4 10l6.5-6.5z"></path></svg>
              <span class="select-menu-item-text css-truncate-target js-select-menu-filter-text">
                master
              </span>
            </a>
        </div>

          <div class="select-menu-no-results">Nothing to show</div>
      </div>

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="tags">
        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


        </div>

        <div class="select-menu-no-results">Nothing to show</div>
      </div>

    </div>
  </div>
</div>

  <div class="btn-group float-right">
    <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/find/master"
          class="js-pjax-capture-input btn btn-sm"
          data-pjax
          data-hotkey="t">
      Find file
    </a>
    <button aria-label="Copy file path to clipboard" class="js-zeroclipboard btn btn-sm zeroclipboard-button tooltipped tooltipped-s" data-copied-hint="Copied!" type="button">Copy path</button>
  </div>
  <div class="breadcrumb js-zeroclipboard-target">
    <span class="repo-root js-repo-root"><span class="js-path-segment"><a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera"><span>Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera</span></a></span></span><span class="separator">/</span><span class="js-path-segment"><a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/tree/master/Project%2001"><span>Project 01</span></a></span><span class="separator">/</span><strong class="final-path">PA1_template.md</strong>
  </div>
</div>

<include-fragment class="commit-tease" src="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/contributors/master/Project%2001/PA1_template.md">
  <div>
    Fetching contributors&hellip;
  </div>

  <div class="commit-tease-contributors">
    <img alt="" class="loader-loading float-left" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32-EAF2F5.gif" width="16" />
    <span class="loader-error">Cannot retrieve contributors at this time</span>
  </div>
</include-fragment>
<div class="file">
  <div class="file-header">
  <div class="file-actions">

    <div class="btn-group">
      <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/raw/master/Project%2001/PA1_template.md" class="btn btn-sm " id="raw-url">Raw</a>
        <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/blame/master/Project%2001/PA1_template.md" class="btn btn-sm js-update-url-with-hash">Blame</a>
      <a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/commits/master/Project%2001/PA1_template.md" class="btn btn-sm " rel="nofollow">History</a>
    </div>

        <a class="btn-octicon tooltipped tooltipped-nw"
           href="github-windows://openRepo/https://github.com/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera?branch=master&amp;filepath=Project%2001%2FPA1_template.md"
           aria-label="Open this file in GitHub Desktop"
           data-ga-click="Repository, open with desktop, type:windows">
            <svg aria-hidden="true" class="octicon octicon-device-desktop" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M15 2H1c-.55 0-1 .45-1 1v9c0 .55.45 1 1 1h5.34c-.25.61-.86 1.39-2.34 2h8c-1.48-.61-2.09-1.39-2.34-2H15c.55 0 1-.45 1-1V3c0-.55-.45-1-1-1zm0 9H1V3h14v8z"></path></svg>
        </a>

        <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/edit/master/Project%2001/PA1_template.md" class="inline-form js-update-url-with-hash" data-form-nonce="f934ea0f0e02464d419648201788eb473d8c0167" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="V+FcCRf0eNsK/uCAwN3eNnNsUO3DjkQ1AtggnRRuFFswBatoOcEV/omo6quUk07+25rbrVtsj2gm/UfZeLY8NQ==" /></div>
          <button class="btn-octicon tooltipped tooltipped-nw" type="submit"
            aria-label="Fork this project and edit the file" data-hotkey="e" data-disable-with>
            <svg aria-hidden="true" class="octicon octicon-pencil" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path d="M0 12v3h3l8-8-3-3-8 8zm3 2H1v-2h1v1h1v1zm10.3-9.3L12 6 9 3l1.3-1.3a.996.996 0 0 1 1.41 0l1.59 1.59c.39.39.39 1.02 0 1.41z"></path></svg>
          </button>
</form>        <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/delete/master/Project%2001/PA1_template.md" class="inline-form" data-form-nonce="f934ea0f0e02464d419648201788eb473d8c0167" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="tWBRV5Hp/8RgKLnxsY1fGOARNh2uIxvjkbUb9GuSguaAyNtCyR2yZZHXsyemfs6t62Y4ycenGhTufgtDYGNQxA==" /></div>
          <button class="btn-octicon btn-octicon-danger tooltipped tooltipped-nw" type="submit"
            aria-label="Fork this project and delete the file" data-disable-with>
            <svg aria-hidden="true" class="octicon octicon-trashcan" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path d="M11 2H9c0-.55-.45-1-1-1H5c-.55 0-1 .45-1 1H2c-.55 0-1 .45-1 1v1c0 .55.45 1 1 1v9c0 .55.45 1 1 1h7c.55 0 1-.45 1-1V5c.55 0 1-.45 1-1V3c0-.55-.45-1-1-1zm-1 12H3V5h1v8h1V5h1v8h1V5h1v8h1V5h1v9zm1-10H2V3h9v1z"></path></svg>
          </button>
</form>  </div>

  <div class="file-info">
      158 lines (120 sloc)
      <span class="file-info-divider"></span>
    3.83 KB
  </div>
</div>

  
  <div id="readme" class="readme blob instapaper_body">
    <article class="markdown-body entry-content" itemprop="text"><h1><a id="user-content-reproducible-research-peer-assessment-1" class="anchor" href="#reproducible-research-peer-assessment-1" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Reproducible Research: Peer Assessment 1</h1>

<h2><a id="user-content-loading-and-preprocessing-the-data" class="anchor" href="#loading-and-preprocessing-the-data" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Loading and preprocessing the data</h2>

<div class="highlight highlight-source-r"><pre>unzip(<span class="pl-v">zipfile</span><span class="pl-k">=</span><span class="pl-s"><span class="pl-pds">"</span>activity.zip<span class="pl-pds">"</span></span>)
<span class="pl-smi">data</span> <span class="pl-k">&lt;-</span> read.csv(<span class="pl-s"><span class="pl-pds">"</span>activity.csv<span class="pl-pds">"</span></span>)</pre></div>

<h2><a id="user-content-what-is-mean-total-number-of-steps-taken-per-day" class="anchor" href="#what-is-mean-total-number-of-steps-taken-per-day" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>What is mean total number of steps taken per day?</h2>

<div class="highlight highlight-source-r"><pre>library(<span class="pl-smi">ggplot2</span>)
<span class="pl-smi">total.steps</span> <span class="pl-k">&lt;-</span> tapply(<span class="pl-smi">data</span><span class="pl-k">$</span><span class="pl-smi">steps</span>, <span class="pl-smi">data</span><span class="pl-k">$</span><span class="pl-smi">date</span>, <span class="pl-v">FUN</span><span class="pl-k">=</span><span class="pl-smi">sum</span>, <span class="pl-v">na.rm</span><span class="pl-k">=</span><span class="pl-c1">TRUE</span>)
qplot(<span class="pl-smi">total.steps</span>, <span class="pl-v">binwidth</span><span class="pl-k">=</span><span class="pl-c1">1000</span>, <span class="pl-v">xlab</span><span class="pl-k">=</span><span class="pl-s"><span class="pl-pds">"</span>total number of steps taken each day<span class="pl-pds">"</span></span>)</pre></div>

<p><a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/blob/master/Project%2001/figure/unnamed-chunk-1-1.png" target="_blank"><img src="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/raw/master/Project%2001/figure/unnamed-chunk-1-1.png" alt="plot of chunk unnamed-chunk-1" style="max-width:100%;"></a> </p>

<div class="highlight highlight-source-r"><pre>mean(<span class="pl-smi">total.steps</span>, <span class="pl-v">na.rm</span><span class="pl-k">=</span><span class="pl-c1">TRUE</span>)</pre></div>

<pre><code>## [1] 9354.23
</code></pre>

<div class="highlight highlight-source-r"><pre>median(<span class="pl-smi">total.steps</span>, <span class="pl-v">na.rm</span><span class="pl-k">=</span><span class="pl-c1">TRUE</span>)</pre></div>

<pre><code>## [1] 10395
</code></pre>

<h2><a id="user-content-what-is-the-average-daily-activity-pattern" class="anchor" href="#what-is-the-average-daily-activity-pattern" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>What is the average daily activity pattern?</h2>

<div class="highlight highlight-source-r"><pre>library(<span class="pl-smi">ggplot2</span>)
<span class="pl-smi">averages</span> <span class="pl-k">&lt;-</span> aggregate(<span class="pl-v">x</span><span class="pl-k">=</span><span class="pl-k">list</span>(<span class="pl-v">steps</span><span class="pl-k">=</span><span class="pl-smi">data</span><span class="pl-k">$</span><span class="pl-smi">steps</span>), <span class="pl-v">by</span><span class="pl-k">=</span><span class="pl-k">list</span>(<span class="pl-v">interval</span><span class="pl-k">=</span><span class="pl-smi">data</span><span class="pl-k">$</span><span class="pl-smi">interval</span>),
                      <span class="pl-v">FUN</span><span class="pl-k">=</span><span class="pl-smi">mean</span>, <span class="pl-v">na.rm</span><span class="pl-k">=</span><span class="pl-c1">TRUE</span>)
ggplot(<span class="pl-v">data</span><span class="pl-k">=</span><span class="pl-smi">averages</span>, aes(<span class="pl-v">x</span><span class="pl-k">=</span><span class="pl-smi">interval</span>, <span class="pl-v">y</span><span class="pl-k">=</span><span class="pl-smi">steps</span>)) <span class="pl-k">+</span>
    geom_line() <span class="pl-k">+</span>
    xlab(<span class="pl-s"><span class="pl-pds">"</span>5-minute interval<span class="pl-pds">"</span></span>) <span class="pl-k">+</span>
    ylab(<span class="pl-s"><span class="pl-pds">"</span>average number of steps taken<span class="pl-pds">"</span></span>)</pre></div>

<p><a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/blob/master/Project%2001/figure/unnamed-chunk-2-1.png" target="_blank"><img src="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/raw/master/Project%2001/figure/unnamed-chunk-2-1.png" alt="plot of chunk unnamed-chunk-2" style="max-width:100%;"></a> </p>

<p>On average across all the days in the dataset, the 5-minute interval contains
the maximum number of steps?</p>

<div class="highlight highlight-source-r"><pre><span class="pl-smi">averages</span>[which.max(<span class="pl-smi">averages</span><span class="pl-k">$</span><span class="pl-smi">steps</span>),]</pre></div>

<pre><code>##     interval    steps
## 104      835 206.1698
</code></pre>

<h2><a id="user-content-imputing-missing-values" class="anchor" href="#imputing-missing-values" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Imputing missing values</h2>

<p>There are many days/intervals where there are missing values (coded as <code>NA</code>). The presence of missing days may introduce bias into some calculations or summaries of the data.</p>

<div class="highlight highlight-source-r"><pre><span class="pl-smi">missing</span> <span class="pl-k">&lt;-</span> is.na(<span class="pl-smi">data</span><span class="pl-k">$</span><span class="pl-smi">steps</span>)
<span class="pl-c"># How many missing</span>
table(<span class="pl-smi">missing</span>)</pre></div>

<pre><code>## missing
## FALSE  TRUE 
## 15264  2304
</code></pre>

<p>All of the missing values are filled in with mean value for that 5-minute
interval.</p>

<div class="highlight highlight-source-r"><pre><span class="pl-c"># Replace each missing value with the mean value of its 5-minute interval</span>
<span class="pl-en">fill.value</span> <span class="pl-k">&lt;-</span> <span class="pl-k">function</span>(<span class="pl-smi">steps</span>, <span class="pl-smi">interval</span>) {
    <span class="pl-smi">filled</span> <span class="pl-k">&lt;-</span> <span class="pl-c1">NA</span>
    <span class="pl-k">if</span> (<span class="pl-k">!</span>is.na(<span class="pl-smi">steps</span>))
        <span class="pl-smi">filled</span> <span class="pl-k">&lt;-</span> c(<span class="pl-smi">steps</span>)
    <span class="pl-k">else</span>
        <span class="pl-smi">filled</span> <span class="pl-k">&lt;-</span> (<span class="pl-smi">averages</span>[<span class="pl-smi">averages</span><span class="pl-k">$</span><span class="pl-smi">interval</span><span class="pl-k">==</span><span class="pl-smi">interval</span>, <span class="pl-s"><span class="pl-pds">"</span>steps<span class="pl-pds">"</span></span>])
    <span class="pl-k">return</span>(<span class="pl-smi">filled</span>)
}
<span class="pl-smi">filled.data</span> <span class="pl-k">&lt;-</span> <span class="pl-smi">data</span>
<span class="pl-smi">filled.data</span><span class="pl-k">$</span><span class="pl-smi">steps</span> <span class="pl-k">&lt;-</span> mapply(<span class="pl-smi">fill.value</span>, <span class="pl-smi">filled.data</span><span class="pl-k">$</span><span class="pl-smi">steps</span>, <span class="pl-smi">filled.data</span><span class="pl-k">$</span><span class="pl-smi">interval</span>)</pre></div>

<p>Now, using the filled data set, let's make a histogram of the total number of steps taken each day and calculate the mean and median total number of steps.</p>

<div class="highlight highlight-source-r"><pre><span class="pl-smi">total.steps</span> <span class="pl-k">&lt;-</span> tapply(<span class="pl-smi">filled.data</span><span class="pl-k">$</span><span class="pl-smi">steps</span>, <span class="pl-smi">filled.data</span><span class="pl-k">$</span><span class="pl-smi">date</span>, <span class="pl-v">FUN</span><span class="pl-k">=</span><span class="pl-smi">sum</span>)
qplot(<span class="pl-smi">total.steps</span>, <span class="pl-v">binwidth</span><span class="pl-k">=</span><span class="pl-c1">1000</span>, <span class="pl-v">xlab</span><span class="pl-k">=</span><span class="pl-s"><span class="pl-pds">"</span>total number of steps taken each day<span class="pl-pds">"</span></span>)</pre></div>

<p><a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/blob/master/Project%2001/figure/unnamed-chunk-5-1.png" target="_blank"><img src="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/raw/master/Project%2001/figure/unnamed-chunk-5-1.png" alt="plot of chunk unnamed-chunk-5" style="max-width:100%;"></a> </p>

<div class="highlight highlight-source-r"><pre>mean(<span class="pl-smi">total.steps</span>)</pre></div>

<pre><code>## [1] 10766.19
</code></pre>

<div class="highlight highlight-source-r"><pre>median(<span class="pl-smi">total.steps</span>)</pre></div>

<pre><code>## [1] 10766.19
</code></pre>

<p>Mean and median values are higher after imputing missing data. The reason is
that in the original data, there are some days with <code>steps</code> values <code>NA</code> for 
any <code>interval</code>. The total number of steps taken in such days are set to 0s by
default. However, after replacing missing <code>steps</code> values with the mean <code>steps</code>
of associated <code>interval</code> value, these 0 values are removed from the histogram
of total number of steps taken each day.</p>

<h2><a id="user-content-are-there-differences-in-activity-patterns-between-weekdays-and-weekends" class="anchor" href="#are-there-differences-in-activity-patterns-between-weekdays-and-weekends" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Are there differences in activity patterns between weekdays and weekends?</h2>

<p>First, let's find the day of the week for each measurement in the dataset. In
this part, we use the dataset with the filled-in values.</p>

<div class="highlight highlight-source-r"><pre><span class="pl-en">weekday.or.weekend</span> <span class="pl-k">&lt;-</span> <span class="pl-k">function</span>(<span class="pl-smi">date</span>) {
    <span class="pl-smi">day</span> <span class="pl-k">&lt;-</span> weekdays(<span class="pl-smi">date</span>)
    <span class="pl-k">if</span> (<span class="pl-smi">day</span> <span class="pl-k">%in%</span> c(<span class="pl-s"><span class="pl-pds">"</span>Monday<span class="pl-pds">"</span></span>, <span class="pl-s"><span class="pl-pds">"</span>Tuesday<span class="pl-pds">"</span></span>, <span class="pl-s"><span class="pl-pds">"</span>Wednesday<span class="pl-pds">"</span></span>, <span class="pl-s"><span class="pl-pds">"</span>Thursday<span class="pl-pds">"</span></span>, <span class="pl-s"><span class="pl-pds">"</span>Friday<span class="pl-pds">"</span></span>))
        <span class="pl-k">return</span>(<span class="pl-s"><span class="pl-pds">"</span>weekday<span class="pl-pds">"</span></span>)
    <span class="pl-k">else</span> <span class="pl-k">if</span> (<span class="pl-smi">day</span> <span class="pl-k">%in%</span> c(<span class="pl-s"><span class="pl-pds">"</span>Saturday<span class="pl-pds">"</span></span>, <span class="pl-s"><span class="pl-pds">"</span>Sunday<span class="pl-pds">"</span></span>))
        <span class="pl-k">return</span>(<span class="pl-s"><span class="pl-pds">"</span>weekend<span class="pl-pds">"</span></span>)
    <span class="pl-k">else</span>
        stop(<span class="pl-s"><span class="pl-pds">"</span>invalid date<span class="pl-pds">"</span></span>)
}
<span class="pl-smi">filled.data</span><span class="pl-k">$</span><span class="pl-smi">date</span> <span class="pl-k">&lt;-</span> as.Date(<span class="pl-smi">filled.data</span><span class="pl-k">$</span><span class="pl-smi">date</span>)
<span class="pl-smi">filled.data</span><span class="pl-k">$</span><span class="pl-smi">day</span> <span class="pl-k">&lt;-</span> sapply(<span class="pl-smi">filled.data</span><span class="pl-k">$</span><span class="pl-smi">date</span>, <span class="pl-v">FUN</span><span class="pl-k">=</span><span class="pl-smi">weekday.or.weekend</span>)</pre></div>

<p>Now, let's make a panel plot containing plots of average number of steps taken
on weekdays and weekends.</p>

<div class="highlight highlight-source-r"><pre><span class="pl-smi">averages</span> <span class="pl-k">&lt;-</span> aggregate(<span class="pl-smi">steps</span> <span class="pl-k">~</span> <span class="pl-smi">interval</span> <span class="pl-k">+</span> <span class="pl-smi">day</span>, <span class="pl-v">data</span><span class="pl-k">=</span><span class="pl-smi">filled.data</span>, <span class="pl-smi">mean</span>)
ggplot(<span class="pl-smi">averages</span>, aes(<span class="pl-smi">interval</span>, <span class="pl-smi">steps</span>)) <span class="pl-k">+</span> geom_line() <span class="pl-k">+</span> facet_grid(<span class="pl-smi">day</span> <span class="pl-k">~</span> .) <span class="pl-k">+</span>
    xlab(<span class="pl-s"><span class="pl-pds">"</span>5-minute interval<span class="pl-pds">"</span></span>) <span class="pl-k">+</span> ylab(<span class="pl-s"><span class="pl-pds">"</span>Number of steps<span class="pl-pds">"</span></span>)</pre></div>

<p><a href="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/blob/master/Project%2001/figure/unnamed-chunk-7-1.png" target="_blank"><img src="/UtkarshPathrabe/Reproducible-Research-Johns-Hopkins-Bloomberg-School-of-Public-Health-Coursera/raw/master/Project%2001/figure/unnamed-chunk-7-1.png" alt="plot of chunk unnamed-chunk-7" style="max-width:100%;"></a> </p>
</article>
  </div>

</div>

<button type="button" data-facebox="#jump-to-line" data-facebox-class="linejump" data-hotkey="l" class="d-none">Jump to Line</button>
<div id="jump-to-line" style="display:none">
  <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="" class="js-jump-to-line-form" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div>
    <input class="form-control linejump-input js-jump-to-line-field" type="text" placeholder="Jump to line&hellip;" aria-label="Jump to line" autofocus>
    <button type="submit" class="btn">Go</button>
</form></div>

  </div>
  <div class="modal-backdrop js-touch-events"></div>
</div>


    </div>
  </div>

    </div>

        <div class="container site-footer-container">
  <div class="site-footer" role="contentinfo">
    <ul class="site-footer-links float-right">
        <li><a href="https://github.com/contact" data-ga-click="Footer, go to contact, text:contact">Contact GitHub</a></li>
      <li><a href="https://developer.github.com" data-ga-click="Footer, go to api, text:api">API</a></li>
      <li><a href="https://training.github.com" data-ga-click="Footer, go to training, text:training">Training</a></li>
      <li><a href="https://shop.github.com" data-ga-click="Footer, go to shop, text:shop">Shop</a></li>
        <li><a href="https://github.com/blog" data-ga-click="Footer, go to blog, text:blog">Blog</a></li>
        <li><a href="https://github.com/about" data-ga-click="Footer, go to about, text:about">About</a></li>

    </ul>

    <a href="https://github.com" aria-label="Homepage" class="site-footer-mark" title="GitHub">
      <svg aria-hidden="true" class="octicon octicon-mark-github" height="24" version="1.1" viewBox="0 0 16 16" width="24"><path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z"></path></svg>
</a>
    <ul class="site-footer-links">
      <li>&copy; 2016 <span title="0.14824s from github-fe130-cp1-prd.iad.github.net">GitHub</span>, Inc.</li>
        <li><a href="https://github.com/site/terms" data-ga-click="Footer, go to terms, text:terms">Terms</a></li>
        <li><a href="https://github.com/site/privacy" data-ga-click="Footer, go to privacy, text:privacy">Privacy</a></li>
        <li><a href="https://github.com/security" data-ga-click="Footer, go to security, text:security">Security</a></li>
        <li><a href="https://status.github.com/" data-ga-click="Footer, go to status, text:status">Status</a></li>
        <li><a href="https://help.github.com" data-ga-click="Footer, go to help, text:help">Help</a></li>
    </ul>
  </div>
</div>



    

    <div id="ajax-error-message" class="ajax-error-message flash flash-error">
      <svg aria-hidden="true" class="octicon octicon-alert" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M8.865 1.52c-.18-.31-.51-.5-.87-.5s-.69.19-.87.5L.275 13.5c-.18.31-.18.69 0 1 .19.31.52.5.87.5h13.7c.36 0 .69-.19.86-.5.17-.31.18-.69.01-1L8.865 1.52zM8.995 13h-2v-2h2v2zm0-3h-2V6h2v4z"></path></svg>
      <button type="button" class="flash-close js-flash-close js-ajax-error-dismiss" aria-label="Dismiss error">
        <svg aria-hidden="true" class="octicon octicon-x" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path d="M7.48 8l3.75 3.75-1.48 1.48L6 9.48l-3.75 3.75-1.48-1.48L4.52 8 .77 4.25l1.48-1.48L6 6.52l3.75-3.75 1.48 1.48z"></path></svg>
      </button>
      You can't perform that action at this time.
    </div>


      
      <script crossorigin="anonymous" integrity="sha256-iEca8f7ED/lBjvvi3dFbaJavjXcvgXkATCVN/8JepJA=" src="https://assets-cdn.github.com/assets/frameworks-88471af1fec40ff9418efbe2ddd15b6896af8d772f8179004c254dffc25ea490.js"></script>
      <script async="async" crossorigin="anonymous" integrity="sha256-n1s1E/w4W+7nu8et44TIMnMzxnFMgoypjC4gI6X8JW4=" src="https://assets-cdn.github.com/assets/github-9f5b3513fc385beee7bbc7ade384c8327333c6714c828ca98c2e2023a5fc256e.js"></script>
      
      
      
      
      
      
    <div class="js-stale-session-flash stale-session-flash flash flash-warn flash-banner d-none">
      <svg aria-hidden="true" class="octicon octicon-alert" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M8.865 1.52c-.18-.31-.51-.5-.87-.5s-.69.19-.87.5L.275 13.5c-.18.31-.18.69 0 1 .19.31.52.5.87.5h13.7c.36 0 .69-.19.86-.5.17-.31.18-.69.01-1L8.865 1.52zM8.995 13h-2v-2h2v2zm0-3h-2V6h2v4z"></path></svg>
      <span class="signed-in-tab-flash">You signed in with another tab or window. <a href="">Reload</a> to refresh your session.</span>
      <span class="signed-out-tab-flash">You signed out in another tab or window. <a href="">Reload</a> to refresh your session.</span>
    </div>
    <div class="facebox" id="facebox" style="display:none;">
  <div class="facebox-popup">
    <div class="facebox-content" role="dialog" aria-labelledby="facebox-header" aria-describedby="facebox-description">
    </div>
    <button type="button" class="facebox-close js-facebox-close" aria-label="Close modal">
      <svg aria-hidden="true" class="octicon octicon-x" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path d="M7.48 8l3.75 3.75-1.48 1.48L6 9.48l-3.75 3.75-1.48-1.48L4.52 8 .77 4.25l1.48-1.48L6 6.52l3.75-3.75 1.48 1.48z"></path></svg>
    </button>
  </div>
</div>

  </body>
</html>

