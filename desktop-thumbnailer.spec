%define _debugsource_template %{nil}
%define debug_package %{nil}

Name:           desktop-thumbnailer
Version:        0.1.0
Release:        1%{?dist}
Summary:        Linux .desktop thumbnailer

License:        GPL-3.0-or-later
URL:            https://github.com/sachesi/desktop-thumbnailer
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  rust cargo

%description
A simple Linux .desktop thumbnailer written in Rust.

%prep
%autosetup

%build
cargo build --release

%install
install -Dm0755 target/release/desktop-thumbnailer %{buildroot}%{_bindir}/desktop-thumbnailer
install -Dm0644 desktop-thumbnailer.thumbnailer %{buildroot}%{_datadir}/thumbnailers/desktop-thumbnailer.thumbnailer

%files
%license LICENSE
%doc README.md
%{_bindir}/desktop-thumbnailer
%{_datadir}/thumbnailers/desktop-thumbnailer.thumbnailer

%post
:

%postun
:

%changelog
* Sat May 17 2025 sachesi x <sachesi.bb.passp@proton.me> - 0.1.0-1
- Initial package
