package t::common;

use Mojo::Base 'Test::Class';
use t::Util;
use Test::More;
use Test::Mojo;

has [qw/t app ua tx/];

has server_session => sub {
    my $self           = shift;
    my $server_session = t::Util::server_session( $self->t->app );
    $server_session->load( $self->sid );
    return $server_session;
};

sub admin_logged_in {
    my $self = shift;

    my $post_data = {
        login_id   => 'staff',
        password   => '12345678',
        csrf_token => $self->csrf_token,
    };

    $self->t->post_ok( $self->app->url_for('RN_admin_login'), form => $post_data );
    is $self->server_session->staff_id, 223, 'right staff logged in';
}

sub cookie_value {
    my ( $self, $name ) = @_;

    my ($cookie) = grep { $_->name eq $name } @{ $self->t->ua->cookie_jar->all };
    return unless $cookie;

    return $cookie->value;
}

sub csrf_token { t::Util::get_csrf_token( shift->t ) }

sub customer_logged_in {
    my $self = shift;

    my $post_data = {
        email      => 'c@example.org',
        password   => '12345678',
        csrf_token => $self->csrf_token,
    };

    $self->t->post_ok( $self->app->url_for('RN_customer_login'), form => $post_data );
    is $self->server_session->customer_id, 111, 'right customer logged in';
}

sub make_path {
    my ( $self, $route, $args ) = @_;
    return $route->is_endpoint ? $route->render($args) : $self->make_path( $route->children );
}

sub make_paths {
    my ( $self, $routes, $args ) = @_;

    my @paths;
    foreach my $r ( @{$routes} ) {
        if ( $r->is_endpoint ) { push @paths, $r->render($args) }
        else                   { $self->make_paths( $r->children ) }
    }
    return \@paths;
}

sub sid { t::Util::get_sid( shift->t ) }

sub startup : Test(startup) {
    my $self = shift;

    my $t = Test::Mojo->new('App');
    $t->app->controller_class('Yetie::Controller');

    $self->{t}   = $t;
    $self->{app} = $t->app;
    $self->{ua}  = $t->ua;
    $self->{tx}  = $t->tx;

    $t->ua->get('/');

    # redirect
    $self->ua->max_redirects(1);
}

1;

=encoding utf8

=head1 NAME

t::common

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 FUNCTIONS

L<t::common> inherits all functions from L<Test::Class> and implements
the following new ones.

=head1 ATTRIBUTES

L<t::common> inherits all attributes from L<Test::Class> and implements
the following new ones.

=head2 C<app>

=head2 C<server_session>

=head2 C<t>

=head2 C<tx>

=head2 C<ua>

=head1 METHODS

L<t::common> inherits all methods from L<Test::Class> and implements
the following new ones.

=head2 C<admin_logged_in>

    $self->admin_logged_in;

Stuff logged-in.

=head2 C<cookie_value>

    my $value = $self->cookie_value($name);

Get cookie value.

=head2 C<csrf_token>

    my $token = $self->csrf_token;

=head2 C<customer_logged_in>

    $self->customer_logged_in;

Customer logged-in.

=head2 C<make_path>

=head2 C<make_paths>

=head2 C<sid>

    my $sid = $self->sid;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Test::Class>, L<t::Util>
