#!/usr/bin/env python3
import argparse
import json
import pathlib
import string


STATUSES = ['open', 'closed']
REGISTRY_PATH = pathlib.Path.home().joinpath('.tickets.json')


def load_tickets():
    if REGISTRY_PATH.exists():
        return json.loads(REGISTRY_PATH.read_text())
    else:
        return []


def save_tickets(tickets):
    tickets_json = json.dumps(tickets, ensure_ascii=False, indent=2)
    REGISTRY_PATH.write_text(tickets_json + '\n')


def do_new(args):
    tickets = load_tickets()
    tickets += [{
        'id': len(tickets)+1,
        'title': args.title,
        'status': args.status,
    }]
    save_tickets(tickets)


def do_edit(args):
    tickets = load_tickets()
    ticket = next(iter([t for t in tickets if t['id'] == args.id]), None)
    if ticket is None:
        raise Exception('label not found')
    ticket['status'] = args.status or ticket['status']
    ticket['title'] = args.title or ticket['title']
    save_tickets(tickets)


def do_list(args):
    tickets = load_tickets()
    template = string.Template(args.format)
    for ticket in tickets:
        if ticket['status'] == args.status or args.status == 'all':
            print(template.substitute(ticket))


def main():
    parser = argparse.ArgumentParser(prog='ticket')
    subparsers = parser.add_subparsers(required=True)
    new_parser = subparsers.add_parser('new')
    new_parser.add_argument('-s', '--status', choices=STATUSES, default='open')
    new_parser.add_argument('title', type=str)
    new_parser.set_defaults(handler=do_new)
    edit_parser = subparsers.add_parser('edit')
    edit_parser.add_argument('-s', '--status', choices=STATUSES)
    edit_parser.add_argument('-t', '--title', type=str)
    edit_parser.add_argument('id', metavar='ID', type=int)
    edit_parser.set_defaults(handler=do_edit)
    list_parser = subparsers.add_parser('list')
    list_parser.add_argument('-f', '--format', type=str, default='$id: $title')
    list_parser.add_argument('-s', '--status', choices=(STATUSES + ['all']), default='open')
    list_parser.set_defaults(handler=do_list)

    args = parser.parse_args()
    args.handler(args)


if __name__ == '__main__':
    main()
