---
title: Maintenance Policy for Ruby on Rails
author: Ruby on Rails
rights: Creative Commons Attribution-ShareAlike 4.0 International
language: en-US
...

# Maintenance Policy for Ruby on Rails

Support of the Rails framework is divided into four groups: New features, bug
fixes, security issues, and severe security issues. They are handled as
follows, all versions in X.Y.Z format.


Rails follows a shifted version of [semver](http://semver.org/):



Only bug fixes, no API changes, no new features.
Except as necessary for security fixes.



New features, may contain API changes (Serve as major versions of Semver).
Breaking changes are paired with deprecation notices in the previous minor
or major release.



New features, will likely contain API changes. The difference between Rails'
minor and major releases is the magnitude of breaking changes, and usually
reserved for special occasions.

# 1 New Features

New features are only added to the master branch and will not be made available
in point releases.

# 2 Bug Fixes

Only the latest release series will receive bug fixes. When enough bugs are
fixed and its deemed worthy to release a new gem, this is the branch it happens
from.

In special situations, where someone from the Core Team agrees to support more series,
they are included in the list of supported series.

`4.2.Z`, `4.1.Z` (Supported by Rafael França).

# 3 Security Issues

The current release series and the next most recent one will receive patches
and new versions in case of a security issue.

These releases are created by taking the last released version, applying the
security patches, and releasing. Those patches are then applied to the end of
the x-y-stable branch. For example, a theoretical 1.2.3 security release would
be built from 1.2.2, and then added to the end of 1-2-stable. This means that
security releases are easy to upgrade to if you're running the latest version
of Rails.

`4.2.Z`, `4.1.Z`.

# 4 Severe Security Issues

For severe security issues we will provide new versions as above, and also the
last major release series will receive patches and new versions. The
classification of the security issue is judged by the core team.

`4.2.Z`, `4.1.Z`, `3.2.Z`.

# 5 Unsupported Release Series

When a release series is no longer supported, it's your own responsibility to
deal with bugs and security issues. We may provide backports of the fixes and
publish them to git, however there will be no new versions released. If you are
not comfortable maintaining your own versions, you should upgrade to a
supported version.

# Feedback

You're encouraged to help improve the quality of this guide.

Please contribute if you see any typos or factual errors.
          To get started, you can read our [documentation contributions](http://edgeguides.rubyonrails.org/contributing_to_ruby_on_rails.html#contributing-to-the-rails-documentation) section.

You may also find incomplete content, or stuff that is not up to date.
          Please do add any missing documentation for master. Make sure to check
          [Edge Guides](http://edgeguides.rubyonrails.org) first to verify
          if the issues are already fixed or not on the master branch.
          Check the [Ruby on Rails Guides Guidelines](ruby_on_rails_guides_guidelines.html)
          for style and conventions.

If for whatever reason you spot something to fix but cannot patch it yourself, please
          [open an issue](https://github.com/rails/rails/issues).

And last but not least, any kind of discussion regarding Ruby on Rails
          documentation is very welcome in the [rubyonrails-docs mailing list](http://groups.google.com/group/rubyonrails-docs).

