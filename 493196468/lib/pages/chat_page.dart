import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entities/message.dart';

class ChatPage extends StatefulWidget {
  final String chatTitle;

  const ChatPage({Key? key, required this.chatTitle}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> _messages = [];
  final List<Message> _favoriteMessages = [];
  final _messageController = TextEditingController();
  int? _indexOfEditableMessage;
  final _textFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget _loadMessages() {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: _messages.length,
        itemBuilder: (context, index) => _messageBuild(index),
      ),
    );
  }

  void _deleteMessage(int index) => _messages.removeAt(index);

  Widget _messageBuild(int index) {
    return GestureDetector(
      onTapDown: _getTapPosition,
      onLongPress: () => _showContextMenu(context, index),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            margin: const EdgeInsets.all(8),
            constraints: const BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(5),
            ),
            child: SelectableText(_messages.reversed.elementAt(index).text),
          ),
        ],
      ),
    );
  }

  Widget _loadFormField() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 50),
      color: Theme.of(context).primaryColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _addAssetsButton(),
          _addTextFormField(),
          _addSubmitButton(),
        ],
      ),
    );
  }

  Widget _addAssetsButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.add),
    );
  }

  Widget _addTextFormField() {
    return Expanded(
      child: Form(
        key: _textFormKey,
        child: TextFormField(
          controller: _messageController,
          decoration: InputDecoration(
            hintText: 'Write your event',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColorLight,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColorLight,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColorLight,
                width: 2.0,
              ),
            ),
          ),
          validator: (value) {
            if (value != null) {
              return value.isEmpty ? 'Message is empty' : null;
            } else {
              return 'Message is empty';
            }
          },
          onSaved: (value) {
            if (value != null) _messageAdd(value);
          },
        ),
      ),
    );
  }

  Widget _addSubmitButton() {
    return IconButton(
      onPressed: () {
        final isValid = _textFormKey.currentState?.validate();
        if (isValid!) {
          _indexOfEditableMessage == null
              ? _textFormKey.currentState?.save()
              : _messages
                  .elementAt(_indexOfEditableMessage!)
                  .edit(_messageController.text);
        }
        _textFormKey.currentState?.reset();
        _indexOfEditableMessage = null;
        setState(() {});
      },
      icon: const Icon(Icons.arrow_forward),
    );
  }

  void _messageAdd(String text) => _messages.add(Message(text));

  void _messageAddToFavorite(int index) {
    if (!_favoriteMessages.contains(_messages.reversed.elementAt(index))) {
      _favoriteMessages.add(_messages.reversed.elementAt(index));
    }
  }

  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails details) {
    final referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  void _showContextMenu(BuildContext context, int index) async {
    final overlay = Overlay.of(context)?.context.findRenderObject();

    final result = await showMenu(
        shape: RoundedRectangleBorder(
          side:
              BorderSide(color: Theme.of(context).primaryColorLight, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          const PopupMenuItem(
            value: 'favorite',
            child: Text('Add to favorites'),
          ),
          const PopupMenuItem(
            value: 'Copy',
            child: Text('Copy'),
          ),
          const PopupMenuItem(
            value: 'Edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: 'Delete',
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ]);

    switch (result) {
      case 'favorite':
        _messageAddToFavorite(index);
        debugPrint(_favoriteMessages.toString());
        break;
      case 'Copy':
        _copyMessage(index);
        break;
      case 'Edit':
        _editMessage(index);
        break;
      case 'Delete':
        _deleteMessage(index);
        setState(() {});
        break;
    }
  }

  void _copyMessage(int index) async {
    await Clipboard.setData(
        ClipboardData(text: _messages.reversed.elementAt(index).text));
  }

  void _editMessage(int index) {
    _messageController.text = _messages.reversed.elementAt(index).text;
    _indexOfEditableMessage = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _loadMessages(),
            _loadFormField(),
          ],
        ),
      ),
    );
  }
}
