import 'package:flutter/material.dart';
import '../models/produto_model.dart';
import '../services/produto_banco.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Produto> _produtos = [];

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final produtos = await ProdutoBanco.instance.getProdutos();
    setState(() {
      _produtos = produtos;
    });
  }

  Future<void> _guardarProduto(int? idProduto) async {
    if (_nomeController.text.isEmpty || _valorController.text.isEmpty) {
      return;
    }

    final produto = Produto(
      id: idProduto,
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      categoria: _categoriaController.text,
      valor: double.tryParse(_valorController.text) ?? 0.0,
    );

    if (idProduto == null) {
      await ProdutoBanco.instance.insertProduto(produto);
    } else {
      await ProdutoBanco.instance.updateProduto(produto);
    }

    Navigator.pop(context);
    _carregarProdutos();
  }

  Future<void> _apagarProduto(int id) async {
    await ProdutoBanco.instance.deleteProduto(id);
    _carregarProdutos();
  }

  void _mostrarFormulario([Produto? produtoExistente]) {
    if (produtoExistente != null) {
      _nomeController.text = produtoExistente.nome;
      _descricaoController.text = produtoExistente.descricao;
      _categoriaController.text = produtoExistente.categoria;
      _valorController.text = produtoExistente.valor.toString();
    } else {
      _nomeController.clear();
      _descricaoController.clear();
      _categoriaController.clear();
      _valorController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Produto',
              ),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
              ),
            ),
            TextField(
              controller: _categoriaController,
              decoration: const InputDecoration(
                labelText: 'Categoria',
              ),
            ),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(
                labelText: 'Valor',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _guardarProduto(produtoExistente?.id),
              child: Text(
                produtoExistente == null ? 'Guardar' : 'Atualizar',
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produtos'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final produto = _produtos[index];
          
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(produto.nome),
              subtitle: Text(
                '${produto.categoria} - R\$ ${produto.valor.toStringAsFixed(2)}\n'
                '${produto.descricao}',
              ),
              isThreeLine: true,
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.orange,
                      ),
                      onPressed: () => _mostrarFormulario(produto),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () => _apagarProduto(produto.id!),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}